class UniversityModel {
  final int university_id;
  final String name;
  final String? description;
  final String? logo_path; // asset path (أو من API logo_url)
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

  /// mapper: API/DB Map -> Model
  factory UniversityModel.from_map(Map<String, dynamic> map) {
    return UniversityModel(
      university_id: _as_int(map['university_id']),
      name: (map['name'] ?? '').toString(),
      description: map['description']?.toString(),
      // في MySQL API عندنا اسم الحقل logo_url، لكن الموديل عندك logo_path
      // نخليها ذكية: تقبل الاثنين
      logo_path: (map['logo_path'] ?? map['logo_url'])?.toString(),
      website: map['website']?.toString(),
      created_at: map['created_at']?.toString(),
    );
  }

  /// (اختياري) Model -> Map (مفيد لاحقًا مع cache / update)
  Map<String, dynamic> to_map() => {
    'university_id': university_id,
    'name': name,
    'description': description,
    'logo_path': logo_path,
    'website': website,
    'created_at': created_at,
  };
}

/// helper لتحويل أرقام MySQL (تجي أحيانًا String)
int _as_int(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}
