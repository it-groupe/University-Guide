import 'package:flutter/material.dart';
import '../data/models/profile_model.dart';
import '../data/repositories/profile_repository.dart';

class ProfileController extends ChangeNotifier {
  final ProfileRepository repo;
  ProfileController(this.repo);

  bool isLoading = false;
  String? error;

  bool isUpdating = false;
  String? updateError;

  ProfileModel? profile;

  bool get hasData => profile != null;

  Future<void> load() async {
    if (isLoading) return;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      profile = await repo.getMyProfile();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> update_profile({
    required String full_name,
    required String school,
    String? avatar_url,
  }) async {
    if (isUpdating) return;
    isUpdating = true;
    updateError = null;
    notifyListeners();

    try {
      profile = await repo.updateMyProfile(
        full_name: full_name,
        school: school,
        avatar_url: avatar_url,
      );
    } catch (e) {
      updateError = e.toString();
      rethrow;
    } finally {
      isUpdating = false;
      notifyListeners();
    }
  }

  Future<void> retry() => load();
}
