class QuestionGroupModel {
  final int id;
  final int testId;
  final String code;
  final String name;
  final String? description;
  final int displayOrder;

  const QuestionGroupModel({
    required this.id,
    required this.testId,
    required this.code,
    required this.name,
    this.description,
    required this.displayOrder,
  });

  factory QuestionGroupModel.fromMap(Map<String, Object?> map) {
    return QuestionGroupModel(
      id: map['group_id'] as int,
      testId: map['test_id'] as int,
      code: map['code'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      displayOrder: map['display_order'] as int,
    );
  }
}
