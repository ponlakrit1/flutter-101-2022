class GraphResponse {
  late int monthNo;
  late int amount0;
  late int amount1;

  GraphResponse({required this.monthNo,
    required this.amount0,
    required this.amount1
  });

  factory GraphResponse.fromJson(Map<String, dynamic> json) {
    return GraphResponse(
        monthNo: json["monthNo"] as int,
        amount0: json["amount0"] as int,
        amount1: json["amount1"] as int
    );
  }

  Map<String, dynamic> toJson() => {
    'monthNo': monthNo,
    'amount0': amount0,
    'amount1': amount1
  };
}
