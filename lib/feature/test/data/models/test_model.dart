class TestModel {
  final int id;
  final String code;
  final String name;
  final String version;
  final bool isActive;

  const TestModel({
    required this.id,
    required this.code,
    required this.name,
    required this.version,
    required this.isActive,
  });

  factory TestModel.fromMap(Map<String, Object?> map) {
    return TestModel(
      id: map['test_id'] as int,
      code: map['code'] as String,
      name: map['name'] as String,
      version: map['version'] as String,
      isActive: (map['is_active'] as int) == 1,
    );
  }
}
