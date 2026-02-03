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

  factory CollegeModel.from_map(Map<String, dynamic> map) {
    return CollegeModel(
      college_id: _as_int(map['college_id']),
      university_id: _as_int(map['university_id']),
      name: (map['name'] ?? '').toString(),
      description: map['description']?.toString(),
      // API عندنا: image_url ، الموديل: image_path
      image_path: (map['image_path'] ?? map['image_url'])?.toString(),
    );
  }

  Map<String, dynamic> to_map() => {
    'college_id': college_id,
    'university_id': university_id,
    'name': name,
    'description': description,
    'image_path': image_path,
  };
}

int _as_int(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}
