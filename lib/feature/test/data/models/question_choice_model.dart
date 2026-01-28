class QuestionChoiceModel {
  final int id;
  final int questionId;
  final String code;
  final String text;
  final int? value;
  final int displayOrder;

  const QuestionChoiceModel({
    required this.id,
    required this.questionId,
    required this.code,
    required this.text,
    required this.value,
    required this.displayOrder,
  });

  factory QuestionChoiceModel.fromMap(Map<String, Object?> map) {
    return QuestionChoiceModel(
      id: map['choice_id'] as int,
      questionId: map['question_id'] as int,
      code: map['code'] as String,
      text: map['choice_text'] as String,
      value: map['choice_value'] as int?,
      displayOrder: map['display_order'] as int,
    );
  }
}
