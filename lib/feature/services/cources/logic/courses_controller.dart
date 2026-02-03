import 'package:flutter/material.dart';
import '../data/models/course_model.dart';
import '../data/models/program_model.dart';
import '../data/repositories/courses_repository.dart';

class CoursesController extends ChangeNotifier {
  final CoursesRepository repo;
  CoursesController(this.repo);

  bool isLoading = false;
  String? error;

  List<CourseModel> courses = [];
  List<ProgramModel> programs = [];

  String query = '';
  int? program_id_filter; // فلتر حسب program_id

  List<CourseModel> get filtered {
    final q = query.trim().toLowerCase();

    return courses.where((c) {
      final matchesProgram =
          program_id_filter == null || c.program_id == program_id_filter;
      final matchesQuery =
          q.isEmpty ||
          c.name.toLowerCase().contains(q) ||
          (c.code ?? '').toLowerCase().contains(q);
      return matchesProgram && matchesQuery;
    }).toList();
  }

  Future<void> load() async {
    if (isLoading) return;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      programs = await repo.get_programs();
      courses = await repo.get_courses_catalog();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setQuery(String v) {
    query = v;
    notifyListeners();
  }

  void setProgramFilter(int? programId) {
    program_id_filter = programId;
    notifyListeners();
  }
}
