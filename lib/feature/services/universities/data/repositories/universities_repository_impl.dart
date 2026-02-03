import '../dataSources/universities_local_mock_ds.dart';
import '../models/university_model.dart';
import '../models/college_model.dart';
import '../models/department_model.dart';
import '../models/program_model.dart';
import 'universities_repository.dart';

class UniversitiesRepositoryImpl implements UniversitiesRepository {
  final UniversitiesLocalMockDataSource ds;

  UniversitiesRepositoryImpl({required this.ds});

  @override
  Future<List<UniversityModel>> getUniversities() => ds.getUniversities();

  @override
  Future<List<CollegeModel>> getCollegesByUniversityId(int university_id) {
    return ds.getCollegesByUniversityId(university_id);
  }

  @override
  Future<List<DepartmentModel>> getDepartmentsByCollegeId(int college_id) {
    return ds.getDepartmentsByCollegeId(college_id);
  }

  @override
  Future<List<ProgramModel>> getProgramsByUniversityId(int university_id) {
    return ds.getProgramsByUniversityId(university_id);
  }
}
