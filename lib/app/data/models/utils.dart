import 'dart:math';

import 'package:crypt/crypt.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import "package:hex/hex.dart";
import 'package:convert/convert.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class Utils {
  static String hash(String text) {
    final hashed = Crypt.sha256(text, rounds: 10000, salt: dotenv.env['SALT']);
    return hashed.hash;
  }

  static String randomWords() {
    String randomMnemonic = bip39.generateMnemonic();
    return randomMnemonic;
  }

  static bool validateWords(String mnemonic) {
    final valid = bip39.validateMnemonic(mnemonic);
    return valid;
  }

  static Future<String> privateKeyFromWords(String words) async {
    String seed = bip39.mnemonicToSeedHex(words);
    List<int> seedBytes = hex.decode(seed);
    KeyData master = await ED25519_HD_KEY.getMasterKeyFromSeed(seedBytes);
    String privateKey = HEX.encode(master.key);
    return privateKey;
  }

  static keyStoreFromPrivateKey(String privateKey, String password) {
    final rng = Random.secure();
    final fromHex = EthPrivateKey.fromHex(privateKey);
    Wallet wallet = Wallet.createNew(fromHex, password, rng);
    // debugPrint(wallet.toJson());
    return wallet.toJson();
  }

  static privateKeyFromKeyStore(String keyStore, String password) {
    final wallet = Wallet.fromJson(keyStore, password);
    final unlocked = wallet.privateKey;
    final pk = bytesToHex(unlocked.privateKey);
    // debugPrint('privateKeyFromKeyStore pk:($pk)');
    return pk;
  }

  static Future<String> addressFromPrivateKey(String privateKey) async {
    final private = EthPrivateKey.fromHex(privateKey);
    final address = await private.extractAddress();
    return address.hex;
  }

  static String ellipsisedHash(String hash) {
    return hash.substring(0, 6) + '...' + hash.substring(hash.length - 6);
  }

  static BigInt bigIntFromDouble(double amount) {
    return BigInt.from(amount * pow(10, 18));
  }

  // static int weiAmountFromDouble(double amount) {
  //   return amount * pow(10, 18);
  // }

  static double doubleFromWeiAmount(dynamic weiAmount) {
    final ea = EtherAmount.fromUnitAndValue(EtherUnit.wei, weiAmount);
    final result = ea.getValueInUnit(EtherUnit.ether);
    return result;
  }

  static void copyAndShow(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    Get.snackbar('Copied', 'Copied to clipboard');
  }

  // static bool compareVersion(String currentVersion, String latestVersion) {
  //   for (var i = 0; i < 3; i++) {
  //     final a = int.parse(currentVersion.split('.')[i]);
  //     final b = int.parse(latestVersion.split('.')[i]);
  //     if (a < b) {
  //       return true;
  //     } else {

  //     }
  //   }
  //   return false;
  // }

  static void customDialog({
    required String title,
    required Widget content,
    void Function()? onCancel,
    required void Function()? onConfirm,
    Color? backgroundColor,
  }) {
    Get.defaultDialog(
      title: title,
      titlePadding: const EdgeInsets.symmetric(vertical: 18.0),
      contentPadding: EdgeInsets.zero,
      content: content,
      backgroundColor:
          backgroundColor ?? const Color.fromRGBO(248, 250, 251, 1),
      cancel: OutlinedButton(
          onPressed: () {
            if (onCancel == null) {
              Get.back();
            } else {
              onCancel();
            }
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('Cancel',
                style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.2))),
          )),
      confirm: OutlinedButton(
        onPressed: onConfirm,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Confirm',
            style: TextStyle(color: Color.fromRGBO(130, 0, 255, 1)),
          ),
        ),
      ),
    );
  }
}
