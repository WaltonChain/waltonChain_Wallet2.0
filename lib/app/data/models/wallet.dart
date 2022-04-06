import 'package:hive/hive.dart';

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
}
