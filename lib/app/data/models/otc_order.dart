class OtcOrder {
  final String type;
  final int id;
  final String address;
  final double wtcAmount;
  final double wtaAmount;
  final String status;

  const OtcOrder({
    required this.type,
    required this.id,
    required this.address,
    required this.wtcAmount,
    required this.wtaAmount,
    required this.status,
  });

  OtcOrder copywith({
    String? type,
    int? id,
    String? address,
    double? wtcAmount,
    double? wtaAmount,
    String? status,
  }) =>
      OtcOrder(
        type: type ?? this.type,
        id: id ?? this.id,
        address: address ?? this.address,
        wtcAmount: wtcAmount ?? this.wtcAmount,
        wtaAmount: wtaAmount ?? this.wtaAmount,
        status: status ?? this.status,
      );

  factory OtcOrder.fromJson(Map<String, dynamic> json) => OtcOrder(
        type: json['type'],
        id: json['id'],
        address: json['address'],
        wtcAmount: json['wtcAmount'],
        wtaAmount: json['wtaAmount'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'id': id,
        'address': address,
        'wtcAmount': wtcAmount,
        'wtaAmount': wtaAmount,
        'status': status,
      };
}
