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

  factory ProgramModel.fromMap(Map<String, dynamic> map) {
    return ProgramModel(
      program_id: map['program_id'] as int,
      department_id: map['department_id'] as int,
      name: (map['name'] ?? '') as String,
      degree: (map['degree'] ?? '') as String,
      duration_years: map['duration_years'] as int?,
      description: map['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'program_id': program_id,
    'department_id': department_id,
    'name': name,
    'degree': degree,
    'duration_years': duration_years,
    'description': description,
  };
}
