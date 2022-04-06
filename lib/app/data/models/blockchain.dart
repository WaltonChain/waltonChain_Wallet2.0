// import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:wtc_wallet_app/app/data/constants/blockchain.dart';
import 'package:wtc_wallet_app/app/data/models/utils.dart';

class Blockchain {
  static final Web3Client eth = Web3Client(baseUrl, Client());

  static Future<double> getWtcBalance(String address) async {
    final ethAddress = EthereumAddress.fromHex(address);
    final ethAmount = await eth.getBalance(ethAddress);
    final ethBalance = ethAmount.getValueInUnit(EtherUnit.ether);
    debugPrint('Blockchain.getWtcBalance ethBalance:($ethBalance)');
    return ethBalance;
  }

  static Future<double> getWtcPrice() async {
    final response = await get(Uri(
      scheme: 'https',
      host: 'www.waltonchain.pro',
      port: 3001,
      path: '/price',
    ));
    final wtcPrice = jsonDecode(response.body)[0]['value'];
    debugPrint('Blockchain.getWtcPrice wtcPrice:($wtcPrice)');
    return double.parse(wtcPrice);
  }

  static loadContract(
      {required String filePath,
      required String name,
      required String contractAddress}) async {
    // String abi = await rootBundle.loadString('assets/files/tokenAbi.json');
    String abi = await rootBundle.loadString(filePath);
    // log('Blockchain.loadContract abi:($abi)');
    final contract = DeployedContract(ContractAbi.fromJson(abi, name),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  static query(String functionName, List<dynamic> args) async {
    final tokenContract = await loadContract(
        filePath: 'assets/files/tokenAbi.json',
        name: 'wta',
        contractAddress: wtcToken);
    final ethFunction = tokenContract.function(
      functionName,
    );
    final result = await eth.call(
        contract: tokenContract, function: ethFunction, params: args);
    return result;
  }

  static stakeQuery(String functionName, List<dynamic> args) async {
    final stakeContract = await loadContract(
        filePath: 'assets/files/stakeAbi.json',
        name: 'stake',
        contractAddress: wtcStake);
    final ethFunction = stakeContract.function(
      functionName,
    );
    final result = await eth.call(
        contract: stakeContract, function: ethFunction, params: args);
    return result;
  }

  static Future<double> getWtaBalance(String address) async {
    EthereumAddress ethAddress = EthereumAddress.fromHex(address);
    var response = await query('balanceOf', [ethAddress]);
    var data = response[0];

    var w = EtherAmount.fromUnitAndValue(EtherUnit.wei, data);
    var balance = w.getValueInUnit(EtherUnit.ether);
    debugPrint(
        'Blockchain.getWtaBalance balance:(${balance.runtimeType}, $balance)');
    await eth.dispose();
    return balance;
  }

  static submit(
      String privateKey, String functionName, List<dynamic> args) async {
    final tokenContract = await loadContract(
        filePath: 'assets/files/tokenAbi.json',
        name: 'wta',
        contractAddress: wtcToken);

    var credentials = EthPrivateKey.fromHex(privateKey);
    final address = await Utils.addressFromPrivateKey(privateKey);
    final ethFunction = tokenContract.function(functionName);
    // final from = EthereumAddress.fromHex('')
    final result = await eth.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: tokenContract,
        function: ethFunction,
        parameters: args,
        from: EthereumAddress.fromHex(address),
        gasPrice: EtherAmount.inWei(BigInt.one),
        maxGas: 100000,
        // value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1),
      ),
      chainId: 15,
    );
    return result;
  }

  static swapSubmit(String privateKey, String functionName, List<dynamic>? args,
      int? weiAmount) async {
    final swapContract = await loadContract(
        filePath: 'assets/files/swapAbi.json',
        name: 'swap',
        contractAddress: wtcSwap);

    final address = await Utils.addressFromPrivateKey(privateKey);
    var credentials = EthPrivateKey.fromHex(privateKey);
    final ethFunction = swapContract.function(functionName);
    // final from = EthereumAddress.fromHex('')
    final result = await eth.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: swapContract,
        function: ethFunction,
        parameters: args ?? [],
        from: EthereumAddress.fromHex(address),
        gasPrice: EtherAmount.inWei(BigInt.one),
        maxGas: 100000,
        value: EtherAmount.fromUnitAndValue(EtherUnit.wei, weiAmount ?? 0),
      ),
      chainId: 15,
    );
    return result;
  }

  static stakeSubmit(String privateKey, String functionName,
      List<dynamic>? args, int? weiAmount) async {
    final stakeContract = await loadContract(
        filePath: 'assets/files/stakeAbi.json',
        name: 'stake',
        contractAddress: wtcStake);

    final address = await Utils.addressFromPrivateKey(privateKey);
    var credentials = EthPrivateKey.fromHex(privateKey);
    final ethFunction = stakeContract.function(functionName);
    // final from = EthereumAddress.fromHex('')
    final result = await eth.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: stakeContract,
        function: ethFunction,
        parameters: args ?? [],
        from: EthereumAddress.fromHex(address),
        gasPrice: EtherAmount.inWei(BigInt.one),
        maxGas: 100000,
        value: EtherAmount.fromUnitAndValue(EtherUnit.wei, weiAmount ?? 0),
      ),
      chainId: 15,
    );
    return result;
  }

  static Future<String> transferWTC(
      String privateKey, String to, double amount) async {
    final credentials = EthPrivateKey.fromHex(privateKey);
    final weiAmount = (amount * pow(10, 18)).toInt();
    // todo: check if the send is fail
    final response = await eth.sendTransaction(
      credentials,
      Transaction(
        to: EthereumAddress.fromHex(to),
        gasPrice: EtherAmount.inWei(BigInt.one),
        maxGas: 100000,
        value: EtherAmount.fromUnitAndValue(EtherUnit.wei, weiAmount),
      ),
      chainId: 15,
    );
    debugPrint('Blockchain transferWTC response:($response)');
    await eth.dispose();
    return response;
  }

  static Future<String> transferWTA(
      String privateKey, String to, double amount) async {
    final ethAddress = EthereumAddress.fromHex(to);
    final bigNum = BigInt.from(amount * pow(10, 18));
    var response = await submit(privateKey, "transfer", [ethAddress, bigNum]);
    debugPrint('Blockchain transfer response:($response)');
    return response;
  }

  static wtaToWtc(String privateKey, String? input) async {
    final approved = await approveSwap(privateKey, input);

    if (approved) {
      final weiAmount =
          ((double.tryParse(input ?? '0') ?? 0) * pow(10, 18)).toInt();
      final a = EtherAmount.fromUnitAndValue(EtherUnit.wei, weiAmount);
      final response =
          await swapSubmit(privateKey, "WtaToWtc", [a.getInWei], null);
      debugPrint('Blockchain swap response:($response)');
    }
  }

  static Future queryAllowance(String address) async {
    final ethAddress = EthereumAddress.fromHex(address);
    final wtcSwapEthAddress = EthereumAddress.fromHex(wtcSwap);
    var allowance = await query('allowance', [ethAddress, wtcSwapEthAddress]);
    debugPrint('Blockchain queryAllowance allowance[0]:(${allowance[0]})');
    return allowance[0];
  }

  static Future<bool> approveSwap(String privateKey, String? input) async {
    final address = await Utils.addressFromPrivateKey(privateKey);
    final allowanceNum = await queryAllowance(address);
    final allowanceEthNum =
        EtherAmount.fromUnitAndValue(EtherUnit.wei, allowanceNum);

    var result = true;
    final weiAmount =
        ((double.tryParse(input ?? '0') ?? 0) * pow(10, 18)).toInt();
    if (allowanceEthNum.getValueInUnit(EtherUnit.wei) < weiAmount) {
      Get.defaultDialog(
        title: 'Approve',
        content: const Text('Please Authorize'),
        onCancel: () {
          result = false;
          Get.back();
          Get.snackbar('Approve', 'Not Approved');
        },
        onConfirm: () async {
          final wtcSwapEthAddress = EthereumAddress.fromHex(wtcSwap);
          var approve = await submit(privateKey, 'approve', [
            wtcSwapEthAddress,
            EtherAmount.fromUnitAndValue(EtherUnit.ether, 999999999999999999)
                .getInWei,
          ]);
          debugPrint('Blockchain swap approve:($approve)');
          result = true;
          Get.back();
          Get.snackbar('Approve', 'Approved success');
        },
      );
    }
    return result;
  }

  static wtcToWta(String privateKey, String? input) async {
    // final approved = await approveSwap(address, input);

    // if (approved) {
    final weiAmount =
        ((double.tryParse(input ?? '0') ?? 0) * pow(10, 18)).toInt();
    var response = await swapSubmit(privateKey, "WtcToWta", null, weiAmount);
    debugPrint('Blockchain swap weiAmount:($weiAmount)');
    debugPrint('Blockchain swap response:($response)');
    // return response;
    // }
  }

  static getStaked(String address) async {
    EthereumAddress ethAddress = EthereumAddress.fromHex(address);
    var response = await stakeQuery('balanceOf', [ethAddress]);
    var data = response[0];

    var w = EtherAmount.fromUnitAndValue(EtherUnit.wei, data);
    var balance = w.getValueInUnit(EtherUnit.ether);
    debugPrint(
        'Blockchain.getStacked balance:(${balance.runtimeType}, $balance)');
    await eth.dispose();
    return balance;
  }

  static stake(String privateKey, String? input) async {
    final weiAmount =
        ((double.tryParse(input ?? '0') ?? 0) * pow(10, 18)).toInt();
    var response = await stakeSubmit(privateKey, "stake", null, weiAmount);
    debugPrint('Blockchain stake weiAmount:($weiAmount)');
    debugPrint('Blockchain stake response:($response)');
    return response;
  }

  static withdrawWtc(String privateKey, String? input) async {
    final weiAmount =
        ((double.tryParse(input ?? '0') ?? 0) * pow(10, 18)).toInt();
    var w = EtherAmount.fromUnitAndValue(EtherUnit.wei, weiAmount);
    var response =
        await stakeSubmit(privateKey, "withdraw", [w.getInWei], null);
    debugPrint('Blockchain.withdraw response:($response)');
    return response;
  }

  static getReward(
    String privateKey,
  ) async {
    var response = await stakeSubmit(privateKey, 'getReward', null, null);
    debugPrint('Blockchain.getReward response:($response)');
    return response;
  }

  static showRewards(String address) async {
    // timeInterval, cause it's dynamic change
    EthereumAddress ethAddress = EthereumAddress.fromHex(address);
    var response = await stakeQuery('earned', [ethAddress]);
    var data = response[0];

    var w = EtherAmount.fromUnitAndValue(EtherUnit.wei, data);
    var balance = w.getValueInUnit(EtherUnit.ether);
    debugPrint(
        'Blockchain.showRewards balance:(${balance.runtimeType}, $balance)');
    await eth.dispose();
    return balance;
  }

  static getTvl(double wtcPrice) async {
    var response = await stakeQuery('totalSupply', []);
    var data = response[0];

    var w = EtherAmount.fromUnitAndValue(EtherUnit.wei, data);
    var balance = w.getValueInUnit(EtherUnit.ether);
    debugPrint('Blockchain.getTvl balance:(${balance.runtimeType}, $balance)');
    await eth.dispose();
    var tvl = balance * wtcPrice;
    debugPrint('Blockchain getTvl Tvl:($tvl)');
    return tvl;
  }

  static getApr() async {
    var response = await stakeQuery('totalSupply', []);
    var data = response[0];

    var w = EtherAmount.fromUnitAndValue(EtherUnit.wei, data);
    var balance = w.getValueInUnit(EtherUnit.ether);
    debugPrint('Blockchain.getApr balance:(${balance.runtimeType}, $balance)');
    await eth.dispose();
    var apr = 2000 * 365 / balance * 100;
    debugPrint('Blockchain getApr apr:($apr)');
    return apr;
  }
}
