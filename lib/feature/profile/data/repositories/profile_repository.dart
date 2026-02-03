import '../models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getMyProfile();

  Future<ProfileModel> updateMyProfile({
    required String full_name,
    required String school,
    String? avatar_url,
  });
}
