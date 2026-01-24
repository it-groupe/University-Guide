class LikertPointModel {
  final int id;
  final int scaleId;
  final int value;
  final String label;

  const LikertPointModel({
    required this.id,
    required this.scaleId,
    required this.value,
    required this.label,
  });

  factory LikertPointModel.fromMap(Map<String, Object?> map) {
    return LikertPointModel(
      id: map['point_id'] as int,
      scaleId: map['scale_id'] as int,
      value: map['value'] as int,
      label: map['label'] as String,
    );
  }
}
