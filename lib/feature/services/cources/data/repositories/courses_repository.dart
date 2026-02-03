import '../models/course_model.dart';
import '../models/program_model.dart';

abstract class CoursesRepository {
  Future<List<CourseModel>> get_courses_catalog();
  Future<List<ProgramModel>> get_programs();
}
