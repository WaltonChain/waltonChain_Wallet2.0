import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 1)
class Transaction {
  @HiveField(1)
  String from;
  @HiveField(2)
  String to;
  @HiveField(3)
  String hash;
  @HiveField(4)
  String time;
  @HiveField(5)
  double amount;
  @HiveField(6)
  String token;
  @HiveField(7)
  String? id;
  @HiveField(8)
  bool? status;

  Transaction({
    required this.from,
    required this.to,
    required this.hash,
    required this.time,
    required this.amount,
    required this.token,
    this.id,
    this.status = true,
  });

  Transaction.fromJson(Map json)
      : from = json['from'],
        to = json['to'],
        hash = json['hash'],
        time = json['time'],
        amount = json['amount'],
        token = json['token'],
        id = json['id'],
        status = json['status'];

  toJson() {
    return {
      'from': from,
      'to': to,
      'hash': hash,
      'time': time,
      'amount': amount,
      'token': token,
      'id': id,
      'status': status,
    };
  }

  @override
  String toString() {
    return '''
      {from: $from
      to: $to
      hash: $hash
      time: $time
      amount: $amount
      token: $token
      id: $id
      status: $status}
    ''';
  }
}
