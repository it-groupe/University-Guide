import 'package:flutter_application_9/feature/profile/data/datasource/profile_local_mock_ds.dart';
import '../models/profile_model.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalMockDataSource mockDs;

  ProfileRepositoryImpl({required this.mockDs});

  @override
  Future<ProfileModel> getMyProfile() {
    return mockDs.getMyProfile();
  }

  @override
  Future<ProfileModel> updateMyProfile({
    required String full_name,
    required String school,
    String? avatar_url,
  }) {
    return mockDs.updateMyProfile(
      full_name: full_name,
      school: school,
      avatar_url: avatar_url,
    );
  }
}
