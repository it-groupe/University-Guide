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
}
