class CourseModel {
  final int course_id;
  final int program_id;
  final String name;
  final String? code;
  final int? credit_hours;
  final String? description;

  const CourseModel({
    required this.course_id,
    required this.program_id,
    required this.name,
    this.code,
    this.credit_hours,
    this.description,
  });

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      course_id: map['course_id'] as int,
      program_id: map['program_id'] as int,
      name: (map['name'] ?? '') as String,
      code: map['code'] as String?,
      credit_hours: map['credit_hours'] as int?,
      description: map['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'course_id': course_id,
    'program_id': program_id,
    'name': name,
    'code': code,
    'credit_hours': credit_hours,
    'description': description,
  };
}
