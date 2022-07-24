class Content {
  late int contentId;
  late String contentName;
  late String contentDetail;
  late String imageCoverPath;
  late String imageDetailPath1;
  late String imageDetailPath2;
  late String imageDetailPath3;
  late String imageDetailPath4;
  late String imageDetailPath5;
  late String imageDetailPath6;
  late String audioThPath;
  late String audioHmongPath;
  late String audioKarenPath;
  late String audioYaoPath;
  late String audioLisuPath;
  late String audioLahuPath;
  late String audioAkhaPath;
  late String videoThPath;
  late String videoHmongPath;
  late String videoKarenPath;
  late String videoYaoPath;
  late String videoLisuPath;
  late String videoLahuPath;
  late String videoAkhaPath;

  Content({required this.contentId,
    required this.contentName,
    required this.contentDetail,
    required this.imageCoverPath,
    required this.imageDetailPath1,
    required this.imageDetailPath2,
    required this.imageDetailPath3,
    required this.imageDetailPath4,
    required this.imageDetailPath5,
    required this.imageDetailPath6,
    required this.audioThPath,
    required this.audioHmongPath,
    required this.audioKarenPath,
    required this.audioYaoPath,
    required this.audioLisuPath,
    required this.audioLahuPath,
    required this.audioAkhaPath,
    required this.videoThPath,
    required this.videoHmongPath,
    required this.videoKarenPath,
    required this.videoYaoPath,
    required this.videoLisuPath,
    required this.videoLahuPath,
    required this.videoAkhaPath,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      contentId: json["contentId"] as int,
      contentName: json["contentName"] as String,
      contentDetail: json["contentDetail"] as String,
      imageCoverPath: json["imageCoverPath"] as String,
      imageDetailPath1: json["imageDetailPath1"] ?? "",
      imageDetailPath2: json["imageDetailPath2"] ?? "",
      imageDetailPath3: json["imageDetailPath3"] ?? "",
      imageDetailPath4: json["imageDetailPath4"] ?? "",
      imageDetailPath5: json["imageDetailPath5"] ?? "",
      imageDetailPath6: json["imageDetailPath6"] ?? "",
      audioThPath: json["audioThPath"] ?? "",
      audioHmongPath: json["audioHmongPath"] ?? "",
      audioKarenPath: json["audioKarenPath"] ?? "",
      audioYaoPath: json["audioYaoPath"] ?? "",
      audioLisuPath: json["audioLisuPath"] ?? "",
      audioLahuPath: json["audioLahuPath"] ?? "",
      audioAkhaPath: json["audioAkhaPath"] ?? "",
      videoThPath: json["videoThPath"] ?? "",
      videoHmongPath: json["videoHmongPath"] ?? "",
      videoKarenPath: json["videoKarenPath"] ?? "",
      videoYaoPath: json["videoYaoPath"] ?? "",
      videoLisuPath: json["videoLisuPath"] ?? "",
      videoLahuPath: json["videoLahuPath"] ?? "",
      videoAkhaPath: json["videoAkhaPath"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    'contentId': contentId,
    'contentName': contentName,
    'contentDetail': contentDetail,
    'imageCoverPath': imageCoverPath,
    'imageDetailPath1': imageDetailPath1,
    'imageDetailPath2': imageDetailPath2,
    'imageDetailPath3': imageDetailPath3,
    'imageDetailPath4': imageDetailPath4,
    'imageDetailPath5': imageDetailPath5,
    'imageDetailPath6': imageDetailPath6,
    'audioThPath': audioThPath,
    'audioHmongPath': audioHmongPath,
    'audioKarenPath': audioKarenPath,
    'audioYaoPath': audioYaoPath,
    'audioLisuPath': audioLisuPath,
    'audioLahuPath': audioLahuPath,
    'audioAkhaPath': audioAkhaPath,
    'videoThPath': videoThPath,
    'videoHmongPath': videoHmongPath,
    'videoKarenPath': videoKarenPath,
    'videoYaoPath': videoYaoPath,
    'videoLisuPath': videoLisuPath,
    'videoLahuPath': videoLahuPath,
    'videoAkhaPath': videoAkhaPath,
  };
}
