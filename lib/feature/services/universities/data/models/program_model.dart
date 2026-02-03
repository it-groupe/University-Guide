class ProgramModel {
  final int program_id;
  final int department_id;
  final String name;
  final String degree;
  final int? duration_years;
  final String? description;

  const ProgramModel({
    required this.program_id,
    required this.department_id,
    required this.name,
    required this.degree,
    this.duration_years,
    this.description,
  });

  factory ProgramModel.from_map(Map<String, dynamic> map) {
    return ProgramModel(
      program_id: _as_int(map['program_id']),
      department_id: _as_int(map['department_id']),
      name: (map['name'] ?? '').toString(),

      degree: (map['degree'] ?? 'bachelor').toString(),

      duration_years: _as_nullable_int(map['duration_years']),
      description: map['description']?.toString(),
    );
  }

  Map<String, dynamic> to_map() => {
    'program_id': program_id,
    'department_id': department_id,
    'name': name,
    'degree': degree,
    'duration_years': duration_years,
    'description': description,
  };
}

int _as_int(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

int? _as_nullable_int(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  return int.tryParse(v.toString());
}
