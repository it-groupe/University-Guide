class AnswerModel {
  final int id;
  final int attemptId;
  final int questionId;
  final int? choiceId;
  final int? likertValue;

  const AnswerModel({
    required this.id,
    required this.attemptId,
    required this.questionId,
    required this.choiceId,
    required this.likertValue,
  });

  factory AnswerModel.fromMap(Map<String, Object?> map) {
    return AnswerModel(
      id: map['answer_id'] as int,
      attemptId: map['attempt_id'] as int,
      questionId: map['question_id'] as int,
      choiceId: map['choice_id'] as int?,
      likertValue: map['likert_value'] as int?,
    );
  }
}
