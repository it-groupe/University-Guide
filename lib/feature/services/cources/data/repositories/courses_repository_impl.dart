import '../datasources/courses_local_mock_ds.dart';
import '../models/course_model.dart';
import '../models/program_model.dart';
import 'courses_repository.dart';

class CoursesRepositoryImpl implements CoursesRepository {
  final CoursesLocalMockDataSource localDs;

  CoursesRepositoryImpl({required this.localDs});

  @override
  Future<List<CourseModel>> get_courses_catalog() =>
      localDs.get_courses_catalog();

  @override
  Future<List<ProgramModel>> get_programs() => localDs.get_programs();
}
