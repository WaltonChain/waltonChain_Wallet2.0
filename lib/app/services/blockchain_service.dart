import 'dart:convert';

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

  Future<BlockchainService> init() async {
    final futures = await Future.wait([
      loadContract(
          name: 'tokenContract',
          filePath: 'assets/files/tokenAbi.json',
          address: wtcToken),
      loadContract(
          name: 'swapContract',
          filePath: 'assets/files/swapAbi.json',
          address: wtcSwap),
      loadContract(
          name: 'stakeContract',
          filePath: 'assets/files/stakeAbi.json',
          address: wtcStake),
    ]);
    tokenContract = futures[0];
    swapContract = futures[1];
    stakeContract = futures[2];
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
    int weiAmount = 0,
  }) async {
    final ethFunction = contract.function(functionName);
    final result = await eth.sendTransaction(
      wallet.getCredentials(),
      Transaction.callContract(
        contract: tokenContract,
        function: ethFunction,
        parameters: args,
        from: EthereumAddress.fromHex(wallet.address ?? ''),
        gasPrice: EtherAmount.inWei(BigInt.one),
        maxGas: maxGas,
        value: EtherAmount.fromUnitAndValue(EtherUnit.wei, weiAmount),
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
    final weiAmount = Utils.weiAmountFromDouble(amount);
    final response = await eth.sendTransaction(
        wallet.getCredentials(),
        Transaction(
          to: EthereumAddress.fromHex(to),
          gasPrice: EtherAmount.inWei(BigInt.one),
          maxGas: maxGas,
          value: EtherAmount.fromUnitAndValue(EtherUnit.wei, weiAmount),
        ));
    await eth.dispose();
    return response;
  }

  Future<String> transferWTA(
      {required my_wallet.Wallet wallet,
      required String to,
      required double amount}) async {
    final ea = EthereumAddress.fromHex(to);
    final bigNum = BigInt.from(Utils.weiAmountFromDouble(amount));
    final response = await submitByContract(
        wallet: wallet,
        contract: tokenContract,
        functionName: 'transfer',
        args: [ea, bigNum]);
    return response;
  }

  Future<bool> needApprove(my_wallet.Wallet wallet, double amount) async {
    final ea = EthereumAddress.fromHex(wallet.address ?? '');
    final wtcSwapEa = EthereumAddress.fromHex(wtcSwap);
    final response = await queryByContract(
        contract: tokenContract,
        functionName: 'allowance',
        args: [ea, wtcSwapEa]);
    final allowanceWei =
        EtherAmount.fromUnitAndValue(EtherUnit.wei, response[0]);
    final result = allowanceWei.getValueInUnit(EtherUnit.ether) < amount;
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
    return response;
  }

  Future<String> wtcToWta({
    required my_wallet.Wallet wallet,
    required double amount,
  }) async {
    final weiAmount = Utils.weiAmountFromDouble(amount);
    final response = await submitByContract(
      wallet: wallet,
      contract: swapContract,
      functionName: 'wtcToWta',
      weiAmount: weiAmount,
    );
    return response;
  }

  Future<String> wtaToWtc({
    required my_wallet.Wallet wallet,
    required double amount,
  }) async {
    final weiAmount = Utils.weiAmountFromDouble(amount);
    final weiBigInt =
        EtherAmount.fromUnitAndValue(EtherUnit.wei, weiAmount).getInWei;
    final response = await submitByContract(
        wallet: wallet,
        contract: swapContract,
        functionName: 'wtaToWtc',
        args: [weiBigInt]);
    return response;
  }

  Future<double> getTotalSupply() async {
    final response = await queryByContract(
      contract: stakeContract,
      functionName: 'totalSupply',
    );
    final totalSupply = Utils.doubleFromWeiAmount(response[0]);
    return totalSupply;
  }

  // Future<double> getTvl(double wtcPrice) async {
  //   final response = await queryByContract(
  //     contract: stakeContract,
  //     functionName: 'totalSupply',
  //   );
  //   final totalSupply = Utils.doubleFromWeiAmount(response[0]);
  //   final tvl = totalSupply * wtcPrice;
  //   return tvl;
  // }

  // Future<double> getApr() async {
  //   final response = await queryByContract(
  //     contract: stakeContract,
  //     functionName: 'totalSupply',
  //   );
  //   final totalSupply = Utils.doubleFromWeiAmount(response[0]);
  //   final apr = 2000 * 365 / totalSupply * 100;
  //   return apr;
  // }

  Future<double> getStaked(my_wallet.Wallet wallet) async {
    final ea = EthereumAddress.fromHex(wallet.address ?? '');
    final response = await queryByContract(
      contract: stakeContract,
      functionName: 'balanceOf',
      args: [ea],
    );
    final staked = Utils.doubleFromWeiAmount(response[0]);
    return staked;
  }

  Future<String> stake(
      {required my_wallet.Wallet wallet, required double amount}) async {
    final weiAmount = Utils.weiAmountFromDouble(amount);
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
    final weiAmount = Utils.weiAmountFromDouble(amount);
    final response = await submitByContract(
      wallet: wallet,
      contract: stakeContract,
      functionName: 'withdraw',
      args: [BigInt.from(weiAmount)],
    );
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
    return response;
  }
}
