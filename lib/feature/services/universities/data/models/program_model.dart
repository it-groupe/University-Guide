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
}
