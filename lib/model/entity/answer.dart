class Answer {
  late int answerId;
  late String answerDetail;
  late String audioThPath;
  late String audioHmongPath;
  late String audioKarenPath;
  late String audioYaoPath;
  late String audioLisuPath;
  late String audioLahuPath;
  late String audioAkhaPath;
  late int answerPoint;
  late int questionId;

  Answer({required this.answerId,
    required this.answerDetail,
    required this.audioThPath,
    required this.audioHmongPath,
    required this.audioKarenPath,
    required this.audioYaoPath,
    required this.audioLisuPath,
    required this.audioLahuPath,
    required this.audioAkhaPath,
    required this.answerPoint,
    required this.questionId,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answerId: json["answerId"] as int,
      answerDetail: json["answerDetail"] as String,
      audioThPath: json["audioThPath"] as String,
      audioHmongPath: json["audioHmongPath"] as String,
      audioKarenPath: json["audioKarenPath"] as String,
      audioYaoPath: json["audioYaoPath"] as String,
      audioLisuPath: json["audioLisuPath"] as String,
      audioLahuPath: json["audioLahuPath"] as String,
      audioAkhaPath: json["audioAkhaPath"] as String,
      answerPoint: json["answerPoint"] as int,
      questionId: json["questionId"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'answerId': answerId,
    'answerDetail': answerDetail,
    'audioThPath': audioThPath,
    'audioHmongPath': audioHmongPath,
    'audioKarenPath': audioKarenPath,
    'audioYaoPath': audioYaoPath,
    'audioLisuPath': audioLisuPath,
    'audioLahuPath': audioLahuPath,
    'audioAkhaPath': audioAkhaPath,
    'answerPoint': answerPoint,
    'questionId': questionId,
  };
}
