class EvaluationResult {
  late int evaluationResultId;
  late int result;
  late String evaluationDate;
  late String resultDetail;
  late String specialCode;
  late int evaluationFormId;
  late int momId;

  EvaluationResult({required this.evaluationResultId,
    required this.result,
    required this.evaluationDate,
    required this.resultDetail,
    required this.specialCode,
    required this.evaluationFormId,
    required this.momId,
  });

  factory EvaluationResult.fromJson(Map<String, dynamic> json) {
    return EvaluationResult(
      evaluationResultId: json["evaluationResultId"] as int,
      result: json["result"] as int,
      evaluationDate: json["evaluationDate"] as String,
      resultDetail: json["resultDetail"] as String,
      specialCode: json["specialCode"] as String,
      evaluationFormId: json["evaluationFormId"] as int,
      momId: json["momId"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'evaluationResultId': evaluationResultId,
    'result': result,
    'evaluationDate': evaluationDate,
    'resultDetail': resultDetail,
    'specialCode': specialCode,
    'evaluationFormId': evaluationFormId,
    'momId': momId,
  };
}
