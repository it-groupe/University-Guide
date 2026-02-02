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
}
