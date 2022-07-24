class CountResponse {
  late int amount;

  CountResponse({required this.amount});

  factory CountResponse.fromJson(Map<String, dynamic> json) {
    return CountResponse(
      amount: json["amount"] as int
    );
  }

  Map<String, dynamic> toJson() => {
    'amount': amount
  };
}
