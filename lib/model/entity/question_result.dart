class QuestionResult {
  late int questionResultId;
  late String result;
  late int questionId;
  late int momId;

  QuestionResult({required this.questionResultId,
    required this.result,
    required this.questionId,
    required this.momId,
  });

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    return QuestionResult(
      questionResultId: json["questionResultId"] as int,
      result: json["result"] as String,
      questionId: json["questionId"] as int,
      momId: json["momId"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'questionResultId': questionResultId,
    'result': result,
    'questionId': questionId,
    'momId': momId,
  };
}
