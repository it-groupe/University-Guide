class ProfileModel {
  final int id;
  final String fullName;
  final String school;
  final String? avatarUrl;

  const ProfileModel({
    required this.id,
    required this.fullName,
    required this.school,
    this.avatarUrl,
  });
}
