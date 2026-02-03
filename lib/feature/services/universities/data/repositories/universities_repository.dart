import '../models/university_model.dart';
import '../models/college_model.dart';
import '../models/department_model.dart';
import '../models/program_model.dart';

abstract class UniversitiesRepository {
  Future<List<UniversityModel>> getUniversities();

  Future<List<CollegeModel>> getCollegesByUniversityId(int university_id);

  Future<List<DepartmentModel>> getDepartmentsByCollegeId(int college_id);

  Future<List<ProgramModel>> getProgramsByUniversityId(int university_id);
}
