import '../models/profile_model.dart';

class ProfileLocalMockDataSource {
  Future<ProfileModel> getMyProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return const ProfileModel(
      id: 1,
      fullName: 'أسامة',
      school: 'مجمع الشعب التربوي ',
      avatarUrl: null,
    );
  }
}
