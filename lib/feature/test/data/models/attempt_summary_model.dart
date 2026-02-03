class AttemptSummaryModel {
  final int attempt_id;
  final String started_at;
  final String? completed_at;

  const AttemptSummaryModel({
    required this.attempt_id,
    required this.started_at,
    required this.completed_at,
  });

  factory AttemptSummaryModel.from_map(Map<String, Object?> map) {
    return AttemptSummaryModel(
      attempt_id: map['attempt_id'] as int,
      started_at: map['started_at'] as String,
      completed_at: map['completed_at'] as String?,
    );
  }
}
