class DepartmentModel {
  final int department_id;
  final int college_id;
  final String name;
  final String? description;

  const DepartmentModel({
    required this.department_id,
    required this.college_id,
    required this.name,
    this.description,
  });

  factory DepartmentModel.from_map(Map<String, dynamic> map) {
    return DepartmentModel(
      department_id: _as_int(map['department_id']),
      college_id: _as_int(map['college_id']),
      name: (map['name'] ?? '').toString(),
      description: map['description']?.toString(),
    );
  }

  Map<String, dynamic> to_map() => {
    'department_id': department_id,
    'college_id': college_id,
    'name': name,
    'description': description,
  };
}

int _as_int(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}
