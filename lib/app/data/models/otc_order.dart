class OtcOrder {
  String type;
  int id;
  String address;
  double wtcAmount;
  double wtaAmount;

  OtcOrder({
    required this.type,
    required this.id,
    required this.address,
    required this.wtcAmount,
    required this.wtaAmount,
  });

  OtcOrder.fromJson(Map json)
      : type = json['type'],
        id = json['id'],
        address = json['address'],
        wtcAmount = json['wtcAmount'],
        wtaAmount = json['wtaAmount'];
}
