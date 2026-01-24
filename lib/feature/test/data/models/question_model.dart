class QuestionModel {
  final int id;
  final int groupId;
  final String code;
  final String text;
  final String type; // 'single_choice' أو 'likert'
  final int? scaleId;
  final int displayOrder;
  final bool isRequired;
  final bool isReverse;

  const QuestionModel({
    required this.id,
    required this.groupId,
    required this.code,
    required this.text,
    required this.type,
    required this.scaleId,
    required this.displayOrder,
    required this.isRequired,
    required this.isReverse,
  });

  bool get isLikert => type == 'likert';
  bool get isSingleChoice => type == 'single_choice';

  factory QuestionModel.fromMap(Map<String, Object?> map) {
    return QuestionModel(
      id: map['question_id'] as int,
      groupId: map['group_id'] as int,
      code: map['code'] as String,
      text: map['question_text'] as String,
      type: map['question_type'] as String,
      scaleId: map['scale_id'] as int?,
      displayOrder: map['display_order'] as int,
      isRequired: (map['is_required'] as int) == 1,
      isReverse: (map['is_reverse'] as int) == 1,
    );
  }
}
