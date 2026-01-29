class MajorScoreModel {
  final int majorId;
  final String code;
  final String name;
  final String? college;
  final double score;
  final int rank;

  const MajorScoreModel({
    required this.majorId,
    required this.code,
    required this.name,
    required this.college,
    required this.score,
    required this.rank,
  });

  factory MajorScoreModel.fromMap(Map<String, Object?> map) {
    return MajorScoreModel(
      majorId: map['major_id'] as int,
      code: map['code'] as String,
      name: map['name'] as String,
      college: map['college'] as String?,
      score: (map['score'] as num).toDouble(),
      rank: map['rank_no'] as int,
    );
  }
}
