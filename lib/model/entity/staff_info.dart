class StaffInfo {
  late int staffId;
  late String email;
  late String firstname;
  late String lastname;
  late String address;
  late String telPhone;
  late int staffLevel;
  late String imagePath;
  late int hospitalId;

  String? image;

  StaffInfo({required this.staffId,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.address,
    required this.telPhone,
    required this.staffLevel,
    required this.imagePath,
    required this.hospitalId
  });

  factory StaffInfo.fromJson(Map<String, dynamic> json) {
    return StaffInfo(
      staffId: json["staffId"] as int,
      email: json["email"] as String,
      firstname: json["firstname"] as String,
      lastname: json["lastname"] as String,
      address: json["address"] == null ? "" : json["address"] as String,
      telPhone: json["telPhone"] as String,
      staffLevel: json["staffLevel"] as int,
      imagePath: json["imagePath"] as String,
      hospitalId: json["hospitalId"] as int
    );
  }

  Map<String, dynamic> toJson() => {
    'staffId': staffId,
    'email': email,
    'firstname': firstname,
    'lastname': lastname,
    'address': address,
    'telPhone': telPhone,
    'staffLevel': staffLevel,
    'imagePath': imagePath,
    'hospitalId': hospitalId
  };
}
