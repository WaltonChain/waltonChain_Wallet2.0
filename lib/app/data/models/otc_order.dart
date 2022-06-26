class OtcOrder {
  final String type;
  final int id;
  final String address;
  final double wtcAmount;
  final double wtaAmount;

  const OtcOrder({
    required this.type,
    required this.id,
    required this.address,
    required this.wtcAmount,
    required this.wtaAmount,
  });

  OtcOrder copywith({
    String? type,
    int? id,
    String? address,
    double? wtcAmount,
    double? wtaAmount,
  }) =>
      OtcOrder(
        type: type ?? this.type,
        id: id ?? this.id,
        address: address ?? this.address,
        wtcAmount: wtcAmount ?? this.wtcAmount,
        wtaAmount: wtaAmount ?? this.wtaAmount,
      );

  factory OtcOrder.fromJson(Map<String, dynamic> json) => OtcOrder(
        type: json['type'],
        id: json['id'],
        address: json['address'],
        wtcAmount: json['wtcAmount'],
        wtaAmount: json['wtaAmount'],
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'id': id,
        'address': address,
        'wtcAmount': wtcAmount,
        'wtaAmount': wtaAmount,
      };
}
