import '../models/profile_model.dart';

class ProfileLocalMockDataSource {
  ProfileModel _current = const ProfileModel(
    id: 1,
    full_name: 'اسامة',
    school: 'مجمع  الشعب التربوي',
    avatar_url: null,
  );

  Future<ProfileModel> getMyProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _current;
  }

  Future<ProfileModel> updateMyProfile({
    required String full_name,
    required String school,
    String? avatar_url,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _current = _current.copy_with(
      full_name: full_name,
      school: school,
      avatar_url: avatar_url,
    );
    return _current;
  }
}
