class UniversityModel {
  final int university_id;
  final String name;
  final String? description;
  final String? logo_path; // asset path
  final String? website;
  final String? created_at;

  const UniversityModel({
    required this.university_id,
    required this.name,
    this.description,
    this.logo_path,
    this.website,
    this.created_at,
  });
}
