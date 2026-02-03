class CollegeModel {
  final int college_id;
  final int university_id;
  final String name;
  final String? description;
  final String? image_path;

  const CollegeModel({
    required this.college_id,
    required this.university_id,
    required this.name,
    this.description,
    this.image_path,
  });
}
