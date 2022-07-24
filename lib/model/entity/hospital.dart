class Hospital {
  late int hospitalId;
  late String hospitalName;
  late String email;
  late String telPhone;
  late String provinceCode;
  late String amphurCode;
  late String tumbonCode;
  late String moo;
  late int staffAmount;

  Hospital({required this.hospitalId,
    required this.hospitalName,
    required this.email,
    required this.telPhone,
    required this.provinceCode,
    required this.amphurCode,
    required this.tumbonCode,
    required this.moo,
    required this.staffAmount
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      hospitalId: json["hospitalId"] as int,
      hospitalName: json["hospitalName"] as String,
      email: json["email"] as String,
      telPhone: json["telPhone"] as String,
      provinceCode: json["provinceCode"] as String,
      amphurCode: json["amphurCode"] as String,
      tumbonCode: json["tumbonCode"] as String,
      moo: json["moo"] as String,
      staffAmount: (json["staffAmount"] == null ? 0 : json["staffAmount"] as int),
    );
  }

  Map<String, dynamic> toJson() => {
    'hospitalId': hospitalId,
    'hospitalName': hospitalName,
    'email': email,
    'telPhone': telPhone,
    'provinceCode': provinceCode,
    'amphurCode': amphurCode,
    'tumbonCode': tumbonCode,
    'moo': moo,
    'staffAmount': staffAmount
  };
}
