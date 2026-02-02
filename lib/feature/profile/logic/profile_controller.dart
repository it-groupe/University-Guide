import 'package:flutter/material.dart';
import '../data/models/profile_model.dart';
import '../data/repositories/profile_repository.dart';

class ProfileController extends ChangeNotifier {
  final ProfileRepository repo;
  ProfileController(this.repo);

  bool isLoading = false;
  String? error;

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

  Future<void> retry() => load();
}
