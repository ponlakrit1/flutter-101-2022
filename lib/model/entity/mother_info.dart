class MotherInfo {
  late int momId;
  late String username;
  late String password;
  late String firstname;
  late String lastname;
  late String pid;
  late String email;
  late String address;
  late String telPhone;
  late int pregnantStatus;
  late String gestationalAge;
  late String imagePath;
  late double weight;
  late double height;
  late int highPressure;
  late int lowPressure;
  late int bleedingFlag;
  late int staffId;

  String? image;

  MotherInfo({required this.momId,
    required this.username,
    required this.password,
    required this.firstname,
    required this.lastname,
    required this.pid,
    required this.email,
    required this.address,
    required this.telPhone,
    required this.pregnantStatus,
    required this.gestationalAge,
    required this.imagePath,
    required this.weight,
    required this.height,
    required this.highPressure,
    required this.lowPressure,
    required this.bleedingFlag,
    required this.staffId
  });

  factory MotherInfo.fromJson(Map<String, dynamic> json) {
    return MotherInfo(
      momId: json["momId"] as int,
      username: json["username"] as String,
      password: json["password"] as String,
      firstname: json["firstname"] as String,
      lastname: json["lastname"] as String,
      pid: json["pid"] as String,
      email: json["email"] as String,
      address: json["address"] as String,
      telPhone: json["telPhone"] as String,
      pregnantStatus: json["pregnantStatus"] as int,
      gestationalAge: json["gestationalAge"] as String,
      imagePath: (json["imagePath"] == null ? "" :json["imagePath"] as String),
      weight: json["weight"] as double,
      height: json["height"] as double,
      highPressure: (json["highPressure"] == null ? 0 :json["highPressure"] as int),
      lowPressure: (json["lowPressure"] == null ? 0 :json["lowPressure"] as int),
      bleedingFlag: json["bleedingFlag"] as int,
      staffId: json["staffId"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'momId': momId,
    'username': username,
    'password': password,
    'firstname': firstname,
    'lastname': lastname,
    'pid': pid,
    'email': email,
    'address': address,
    'telPhone': telPhone,
    'pregnantStatus': pregnantStatus,
    'gestationalAge': gestationalAge,
    'imagePath': imagePath,
    'weight': weight,
    'height': height,
    'highPressure': highPressure,
    'lowPressure': lowPressure,
    'bleedingFlag': bleedingFlag,
    'staffId': staffId
  };
}
