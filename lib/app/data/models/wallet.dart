import 'package:hive/hive.dart';
import 'package:web3dart/web3dart.dart';
import 'package:wtc_wallet_app/app/data/models/utils.dart';

part 'wallet.g.dart';

@HiveType(typeId: 0)
class Wallet {
  @HiveField(1)
  String? id;
  @HiveField(2)
  String name;
  @HiveField(3)
  String pass;
  @HiveField(4)
  String? address;
  @HiveField(5)
  String? keyStore;

  Wallet({
    required this.name,
    required this.pass,
    this.address,
    this.keyStore,
  });

  Wallet.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        pass = json['pass'],
        address = json['address'],
        keyStore = json['keyStore'];

  toJson() {
    return {
      'id': id,
      'name': name,
      'pass': pass,
      'address': address,
      'keyStore': keyStore,
    };
  }

  @override
  String toString() {
    return '''
      {
        id: $id
        name: $name
        pass: $pass
        address: $address
        keyStore: $keyStore
      }
    ''';
  }

  getPrivateKey() {
    final pk = Utils.privateKeyFromKeyStore(keyStore ?? '', pass);
    // print('getPrivateKey:($pk)');
    return pk;
  }

  getCredentials() {
    final pk = getPrivateKey();
    final credentials = EthPrivateKey.fromHex(pk);
    return credentials;
  }
}
