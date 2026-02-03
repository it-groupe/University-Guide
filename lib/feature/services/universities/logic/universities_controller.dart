import 'package:flutter/material.dart';

import '../data/models/university_model.dart';
import '../data/models/college_model.dart';
import '../data/models/program_model.dart';
import '../data/repositories/universities_repository.dart';

class UniversitiesController extends ChangeNotifier {
  final UniversitiesRepository repo;
  UniversitiesController(this.repo);

  bool isLoading = false;
  String? error;

  // list
  List<UniversityModel> universities = [];
  List<UniversityModel> filtered = [];
  String query = '';

  // details
  bool isLoadingDetails = false;
  String? detailsError;

  List<CollegeModel> colleges = [];
  List<ProgramModel> programs = [];
  Future<void> load() => loadUniversities();

  // ========= list =========
  Future<void> loadUniversities() async {
    if (isLoading) return;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      universities = await repo.getUniversities();
      _applyFilters();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setQuery(String v) {
    query = v.trim();
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    final q = query.toLowerCase();
    filtered = universities.where((u) {
      if (q.isEmpty) return true;
      return u.name.toLowerCase().contains(q) ||
          (u.description ?? '').toLowerCase().contains(q);
    }).toList();
  }

  // ========= details =========
  Future<void> loadUniversityDetails(int university_id) async {
    if (isLoadingDetails) return;
    isLoadingDetails = true;
    detailsError = null;
    notifyListeners();

    try {
      colleges = await repo.getCollegesByUniversityId(university_id);
      programs = await repo.getProgramsByUniversityId(university_id);
    } catch (e) {
      detailsError = e.toString();
    } finally {
      isLoadingDetails = false;
      notifyListeners();
    }
  }
}
