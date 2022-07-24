class EvaluationForm {
  late int evaluationFormId;
  late String evaluationName;
  late String pregnantWeek;
  late int pregnantStatus;
  late int criteria;
  late String specialCode;
  late String evaluationOwner;
  late int complicationChildBirthPoint;
  late String specialCodeDetail;
  late String nextEvaluation;
  late int evaluationSetId;
  late int contentId;

  EvaluationForm({required this.evaluationFormId,
    required this.evaluationName,
    required this.pregnantWeek,
    required this.pregnantStatus,
    required this.criteria,
    required this.specialCode,
    required this.evaluationOwner,
    required this.complicationChildBirthPoint,
    required this.specialCodeDetail,
    required this.nextEvaluation,
    required this.evaluationSetId,
    required this.contentId,
  });

  factory EvaluationForm.fromJson(Map<String, dynamic> json) {
    return EvaluationForm(
      evaluationFormId: json["evaluationFormId"] as int,
      evaluationName: json["evaluationName"] as String,
      pregnantWeek: json["pregnantWeek"] as String,
      pregnantStatus: json["pregnantStatus"] as int,
      criteria: json["criteria"] as int,
      specialCode: json["specialCode"] as String,
      evaluationOwner: json["evaluationOwner"] as String,
      complicationChildBirthPoint: (json["complicationChildBirthPoint"] == null ? 0 : json["complicationChildBirthPoint"] as int),
      specialCodeDetail: json["specialCodeDetail"] as String,
      nextEvaluation:  (json["nextEvaluation"] == null ? "" : json["nextEvaluation"] as String),
      evaluationSetId: json["evaluationSetId"] as int,
      contentId: (json["contentId"] == null ? 0 : json["contentId"] as int),
    );
  }

  Map<String, dynamic> toJson() => {
    'evaluationFormId': evaluationFormId,
    'evaluationName': evaluationName,
    'pregnantWeek': pregnantWeek,
    'pregnantStatus': pregnantStatus,
    'criteria': criteria,
    'specialCode': specialCode,
    'evaluationOwner': evaluationOwner,
    'complicationChildBirthPoint': complicationChildBirthPoint,
    'specialCodeDetail': specialCodeDetail,
    'nextEvaluation': nextEvaluation,
    'evaluationSetId': evaluationSetId,
    'contentId': contentId,
  };
}
