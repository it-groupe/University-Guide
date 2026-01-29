class QuestionTraitWeightModel {
  final int traitId;
  final double weight;

  const QuestionTraitWeightModel({required this.traitId, required this.weight});

  factory QuestionTraitWeightModel.fromMap(Map<String, Object?> map) {
    return QuestionTraitWeightModel(
      traitId: map['trait_id'] as int,
      weight: (map['weight'] as num).toDouble(),
    );
  }
}
