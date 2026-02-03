class ProfileModel {
  final int id;
  final String full_name;
  final String school;
  final String? avatar_url;

  const ProfileModel({
    required this.id,
    required this.full_name,
    required this.school,
    this.avatar_url,
  });

  ProfileModel copy_with({
    String? full_name,
    String? school,
    String? avatar_url,
  }) {
    return ProfileModel(
      id: id,
      full_name: full_name ?? this.full_name,
      school: school ?? this.school,
      avatar_url: avatar_url ?? this.avatar_url,
    );
  }
}
