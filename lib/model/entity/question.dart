
class Question {
  late int questionId;
  late String questionDetail;
  late String audioThPath;
  late String audioHmongPath;
  late String audioKarenPath;
  late String audioYaoPath;
  late String audioLisuPath;
  late String audioLahuPath;
  late String audioAkhaPath;
  late int questionType;
  late int evaluationFormId;

  List<Map<String, String>>? answerOptionList;
  int? index;

  Question({required this.questionId,
    required this.questionDetail,
    required this.audioThPath,
    required this.audioHmongPath,
    required this.audioKarenPath,
    required this.audioYaoPath,
    required this.audioLisuPath,
    required this.audioLahuPath,
    required this.audioAkhaPath,
    required this.questionType,
    required this.evaluationFormId,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json["questionId"] as int,
      questionDetail: json["questionDetail"] as String,
      audioThPath: json["audioThPath"] as String,
      audioHmongPath: json["audioHmongPath"] as String,
      audioKarenPath: json["audioKarenPath"] as String,
      audioYaoPath: json["audioYaoPath"] as String,
      audioLisuPath: json["audioLisuPath"] as String,
      audioLahuPath: json["audioLahuPath"] as String,
      audioAkhaPath: json["audioAkhaPath"] as String,
      questionType: json["questionType"] as int,
      evaluationFormId: json["evaluationFormId"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'questionDetail': questionDetail,
    'audioThPath': audioThPath,
    'audioHmongPath': audioHmongPath,
    'audioKarenPath': audioKarenPath,
    'audioYaoPath': audioYaoPath,
    'audioLisuPath': audioLisuPath,
    'audioLahuPath': audioLahuPath,
    'audioAkhaPath': audioAkhaPath,
    'questionType': questionType,
    'evaluationFormId': evaluationFormId,
  };
}
