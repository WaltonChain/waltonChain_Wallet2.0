import 'dart:math';

import 'package:crypt/crypt.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
}
