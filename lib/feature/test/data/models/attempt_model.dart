class AttemptModel {
  final int id;
  final int testId;
  final int? studentId;
  final String status; // in_progress | completed
  final String startedAt;
  final String? completedAt;

  const AttemptModel({
    required this.id,
    required this.testId,
    required this.studentId,
    required this.status,
    required this.startedAt,
    required this.completedAt,
  });

  factory AttemptModel.fromMap(Map<String, Object?> map) {
    return AttemptModel(
      id: map['attempt_id'] as int,
      testId: map['test_id'] as int,
      studentId: map['student_id'] as int?,
      status: map['status'] as String,
      startedAt: map['started_at'] as String,
      completedAt: map['completed_at'] as String?,
    );
  }
}
