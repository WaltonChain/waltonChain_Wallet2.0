import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';
import 'package:wtc_wallet_app/app/data/constants/blockchain.dart';
import 'package:http/http.dart';
import 'package:wtc_wallet_app/app/data/models/utils.dart';
import 'package:wtc_wallet_app/app/data/models/wallet.dart' as my_wallet;

class BlockchainService extends GetxService {
  final Web3Client eth = Web3Client(baseUrl, Client());
  late DeployedContract tokenContract;
  late DeployedContract swapContract;
  late DeployedContract stakeContract;
  late DeployedContract otcContract;

  Future<BlockchainService> init() async {
    final futures = await Future.wait([
      loadContract(
        name: 'tokenContract',
        filePath: 'assets/files/tokenAbi.json',
        address: wtaToken,
        // address: wtaTokenTest,
      ),
      loadContract(
        name: 'swapContract',
        filePath: 'assets/files/swapAbi.json',
        address: wtcSwap,
      ),
      loadContract(
        name: 'stakeContract',
        filePath: 'assets/files/stakeAbi.json',
        address: wtcStake,
      ),
      loadContract(
        name: 'otcContract',
        filePath: 'assets/files/otcAbi.json',
        address: otcAddressTest,
      ),
    ]);
    tokenContract = futures[0];
    swapContract = futures[1];
    stakeContract = futures[2];
    otcContract = futures[3];
    return this;
  }

  Future<DeployedContract> loadContract(
      {required String name,
      required String filePath,
      required String address}) async {
    final abi = await rootBundle.loadString(filePath);
    final ea = EthereumAddress.fromHex(address);
    final contract = DeployedContract(ContractAbi.fromJson(abi, name), ea);
    return contract;
  }

  Future<List<dynamic>> queryByContract(
      {required dynamic contract,
      required String functionName,
      List<dynamic> args = const []}) async {
    final ethFunction = contract.function(functionName);
    final result =
        await eth.call(contract: contract, function: ethFunction, params: args);
    await eth.dispose();
    return result;
  }

  Future<String> submitByContract({
    required my_wallet.Wallet wallet,
    required dynamic contract,
    required String functionName,
    List<dynamic> args = const [],
    BigInt? weiAmount,
  }) async {
    final ethFunction = contract.function(functionName);
    final result = await eth.sendTransaction(
      wallet.getCredentials(),
      Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
        from: EthereumAddress.fromHex(wallet.address ?? ''),
        gasPrice: EtherAmount.inWei(BigInt.one),
        maxGas: maxGas,
        value: weiAmount == null
            ? null
            : EtherAmount.fromUnitAndValue(EtherUnit.wei, weiAmount),
      ),
      chainId: chainId,
    );
    await eth.dispose();
    return result;
  }

  Future<double> getWtcPrice() async {
    final response = await get(Uri.parse(wtcPriceUrl));
    final json = jsonDecode(response.body);
    final priceStr = json[0]['value'];
    final price = double.parse(priceStr);
    return price;
  }

  Future<double> getWtcBalance(my_wallet.Wallet wallet) async {
    final ea = EthereumAddress.fromHex(wallet.address ?? '');
    final ethAmount = await eth.getBalance(ea);
    final ethBalance = ethAmount.getValueInUnit(EtherUnit.ether);
    return ethBalance;
  }

  Future<double> getWtaBalance(my_wallet.Wallet wallet) async {
    final ea = EthereumAddress.fromHex(wallet.address ?? '');
    final response = await queryByContract(
        contract: tokenContract, functionName: 'balanceOf', args: [ea]);
    final w = EtherAmount.fromUnitAndValue(EtherUnit.wei, response[0]);
    final wtaBalance = w.getValueInUnit(EtherUnit.ether);
    return wtaBalance;
  }

  Future<String> transferWTC(
      {required my_wallet.Wallet wallet,
      required String to,
      required double amount}) async {
    final weiAmount = Utils.bigIntFromDouble(amount);
    final response = await eth.sendTransaction(
      wallet.getCredentials(),
      Transaction(
        to: EthereumAddress.fromHex(to),
        gasPrice: EtherAmount.inWei(BigInt.one),
        maxGas: maxGas,
        value: EtherAmount.fromUnitAndValue(EtherUnit.wei, weiAmount),
      ),
      chainId: chainId,
    );
    // print('response:($response)');
    await eth.dispose();
    return response;
  }

  Future<String> transferWTA(
      {required my_wallet.Wallet wallet,
      required String to,
      required double amount}) async {
    final ea = EthereumAddress.fromHex(to);
    final weiAmount = Utils.bigIntFromDouble(amount);

    final response = await submitByContract(
        wallet: wallet,
        contract: tokenContract,
        functionName: 'transfer',
        args: [ea, weiAmount]);
    return response;
  }

  Future<bool> needApprove(my_wallet.Wallet wallet, double amount) async {
    final ea = EthereumAddress.fromHex(wallet.address ?? '');
    final wtcSwapEa = EthereumAddress.fromHex(wtcSwap);
    final response = await queryByContract(
        contract: tokenContract,
        functionName: 'allowance',
        args: [ea, wtcSwapEa]);
    // print('needApprove response:($response)');
    final allowanceWei =
        EtherAmount.fromUnitAndValue(EtherUnit.wei, response[0]);
    final result = allowanceWei.getValueInUnit(EtherUnit.ether) < amount;
    // print('needApprove result:($result)');
    return result;
  }

  Future<bool> sellNeedApprove(my_wallet.Wallet wallet, double amount) async {
    final ea = EthereumAddress.fromHex(wallet.address ?? '');
    final wtcSwapEa = EthereumAddress.fromHex(otcAddressTest);
    final response = await queryByContract(
        contract: tokenContract,
        functionName: 'allowance',
        args: [ea, wtcSwapEa]);
    print('sellNeedApprove response:($response)');
    final allowanceWei =
        EtherAmount.fromUnitAndValue(EtherUnit.wei, response[0]);
    final result = allowanceWei.getValueInUnit(EtherUnit.ether) < amount;
    // print('sellNeedApprove result:($result)');
    return result;
  }

  Future approveSwap(
      {required my_wallet.Wallet wallet, required double amount}) async {
    final wtcSwapEa = EthereumAddress.fromHex(wtcSwap);
    final maxApproveWei =
        EtherAmount.fromUnitAndValue(EtherUnit.ether, 999999999999999999)
            .getInWei;
    final response = await submitByContract(
        wallet: wallet,
        contract: tokenContract,
        functionName: 'approve',
        args: [wtcSwapEa, maxApproveWei]);
    // print('approveSwap response:($response)');
    return response;
  }

  Future approveSell(
      {required my_wallet.Wallet wallet, required double amount}) async {
    final wtcSwapEa = EthereumAddress.fromHex(otcAddressTest);
    final maxApproveWei =
        EtherAmount.fromUnitAndValue(EtherUnit.ether, 999999999999999999)
            .getInWei;
    final response = await submitByContract(
        wallet: wallet,
        contract: tokenContract,
        functionName: 'approve',
        args: [wtcSwapEa, maxApproveWei]);
    print('approveSell response:($response)');
    return response;
  }

  Future<String> wtcToWta({
    required my_wallet.Wallet wallet,
    required double amount,
  }) async {
    final weiAmount = Utils.bigIntFromDouble(amount);
    final response = await submitByContract(
      wallet: wallet,
      contract: swapContract,
      functionName: 'WtcToWta',
      weiAmount: weiAmount,
    );
    return response;
  }

  Future<String> wtaToWtc({
    required my_wallet.Wallet wallet,
    required double amount,
  }) async {
    final weiAmount = Utils.bigIntFromDouble(amount);
    final weiBigInt =
        EtherAmount.fromUnitAndValue(EtherUnit.wei, weiAmount).getInWei;
    // print(
    //     'wtaToWtc before response, weiBigInt:($weiBigInt) weiAmount:($weiAmount)');
    final response = await submitByContract(
        wallet: wallet,
        contract: swapContract,
        functionName: 'WtaToWtc',
        args: [weiBigInt]);
    // print('wtaToWtc after response:($response)');
    return response;
  }

  Future<String> stake(
      {required my_wallet.Wallet wallet, required double amount}) async {
    final weiAmount = Utils.bigIntFromDouble(amount);
    final response = await submitByContract(
      wallet: wallet,
      contract: stakeContract,
      functionName: 'stake',
      weiAmount: weiAmount,
    );
    return response;
  }

  Future<String> withdrawWtc(
      {required my_wallet.Wallet wallet, required double amount}) async {
    final weiAmount = Utils.bigIntFromDouble(amount);
    final response = await submitByContract(
      wallet: wallet,
      contract: stakeContract,
      functionName: 'withdraw',
      args: [weiAmount],
    );
    // print('withdrawWtc response:($response) weiAmount:($weiAmount)');
    return response;
  }

  Future<double> getRewarded(my_wallet.Wallet wallet) async {
    final ea = EthereumAddress.fromHex(wallet.address ?? '');
    final response = await queryByContract(
      contract: stakeContract,
      functionName: 'earned',
      args: [ea],
    );
    final rewarded = Utils.doubleFromWeiAmount(response[0]);
    return rewarded;
  }

  Future<String> withdrawReward(my_wallet.Wallet wallet) async {
    final response = await submitByContract(
      wallet: wallet,
      contract: stakeContract,
      functionName: 'getReward',
    );
    // print('withdrawReward response:($response)');
    return response;
  }

  Future<double> getPersonalPower(my_wallet.Wallet wallet) async {
    final ea = EthereumAddress.fromHex(wallet.address ?? '');
    final response = await queryByContract(
      contract: stakeContract,
      functionName: 'hashrateOf',
      args: [ea],
    );
    final power = response[0] / BigInt.from(pow(10, 15));
    return power;
  }

  Future<double> getTotalPower(my_wallet.Wallet wallet) async {
    // final ea = EthereumAddress.fromHex(wallet.address ?? '');
    final response = await queryByContract(
      contract: stakeContract,
      functionName: 'totalHashrate',
      // args: [ea],
    );
    final power = response[0] / BigInt.from(pow(10, 15));
    // print('getTotalPower power:($power)');
    return power;
  }

  Future<String> newStake(
      {required my_wallet.Wallet wallet,
      required double amount,
      required int periodIndex}) async {
    final weiAmount = Utils.bigIntFromDouble(amount);
    final response = await submitByContract(
      wallet: wallet,
      contract: stakeContract,
      functionName: 'stake',
      weiAmount: weiAmount,
      args: [BigInt.from(periodIndex)],
    );
    // print('newStake response:($response)');
    return response;
  }

  Future<List> getOrderIds(my_wallet.Wallet wallet) async {
    final ea = EthereumAddress.fromHex(wallet.address ?? '');
    final response = await queryByContract(
      contract: stakeContract,
      functionName: 'getUserIds',
      args: [ea],
    );
    final orderIds = response[0];
    // print('getOrderIds orderIds:($orderIds)');
    return orderIds;
  }

  Future<List> getOrderDetail(dynamic orderId) async {
    // final ea = EthereumAddress.fromHex(wallet.address ?? '');
    final response = await queryByContract(
      contract: stakeContract,
      functionName: 'orderList',
      args: [orderId],
    );
    // print('getorder response:($response)');
    return response;
  }

  // otc
  Future createBuyOrder(
      {required my_wallet.Wallet wallet,
      required double price,
      required double amount}) async {
    final response = await submitByContract(
      wallet: wallet,
      contract: otcContract,
      functionName: 'createBuyOrder',
      weiAmount: Utils.bigIntFromDouble(price),
      args: [Utils.bigIntFromDouble(amount)],
    );
    // print('createBuyOrder response:($response)');
    return response;
  }

  Future createSellOrder(
      {required my_wallet.Wallet wallet,
      required double price,
      required double amount}) async {
    final a = Utils.bigIntFromDouble(amount);
    final p = Utils.bigIntFromDouble(price);
    final response = await submitByContract(
      wallet: wallet,
      contract: otcContract,
      functionName: 'createSellOrder',
      args: [a, p],
    );
    // print('createSellOrder response:($response), a:($a) p:($p)');
    return response;
  }

  Future orderList({
    required my_wallet.Wallet wallet,
  }) async {
    final ea = EthereumAddress.fromHex(wallet.address ?? '');
    final r1 = await queryByContract(
      contract: otcContract,
      functionName: 'getUserList',
      args: [ea],
    );
    final userLists = r1[0];
    // print('getorder response:($response)');
    final r2 = await queryByContract(
        contract: otcContract, functionName: 'getList', args: [userLists]);
    return r2;
  }
}
