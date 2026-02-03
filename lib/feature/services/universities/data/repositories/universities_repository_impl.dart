import 'package:flutter_application_9/core/cache/cache_keys.dart';
import 'package:flutter_application_9/core/cache/cache_store.dart';
import 'package:flutter_application_9/core/utils/json_utils.dart';

import '../dataSources/universities_local_mock_ds.dart';
import '../dataSources/universities_remote_ds.dart';

import '../models/university_model.dart';
import '../models/college_model.dart';
import '../models/department_model.dart';
import '../models/program_model.dart';

import 'universities_repository.dart';

class UniversitiesRepositoryImpl implements UniversitiesRepository {
  final UniversitiesLocalMockDataSource local_ds;
  final UniversitiesRemoteDataSource remote_ds;
  final CacheStore cache;

  UniversitiesRepositoryImpl({
    required this.local_ds,
    required this.remote_ds,
    required this.cache,
  });

  @override
  Future<List<UniversityModel>> getUniversities() async {
    try {
      final rows = await remote_ds.getUniversities();
      await cache.write_string(CacheKeys.universities_list, encode_json(rows));
      return rows.map((e) => UniversityModel.from_map(e)).toList();
    } catch (_) {
      final raw = await cache.read_string(CacheKeys.universities_list);
      if (raw != null) {
        final rows = List<Map<String, dynamic>>.from(decode_json(raw) as List);
        return rows.map((e) => UniversityModel.from_map(e)).toList();
      }
      return local_ds.getUniversities();
    }
  }

  @override
  Future<List<CollegeModel>> getCollegesByUniversityId(
    int university_id,
  ) async {
    final key = CacheKeys.colleges(university_id);
    try {
      final rows = await remote_ds.getCollegesByUniversityId(university_id);
      await cache.write_string(key, encode_json(rows));
      return rows.map((e) => CollegeModel.from_map(e)).toList();
    } catch (_) {
      final raw = await cache.read_string(key);
      if (raw != null) {
        final rows = List<Map<String, dynamic>>.from(decode_json(raw) as List);
        return rows.map((e) => CollegeModel.from_map(e)).toList();
      }
      return local_ds.getCollegesByUniversityId(university_id);
    }
  }

  @override
  Future<List<DepartmentModel>> getDepartmentsByCollegeId(
    int college_id,
  ) async {
    final key = CacheKeys.departments(college_id);
    try {
      final rows = await remote_ds.getDepartmentsByCollegeId(college_id);
      await cache.write_string(key, encode_json(rows));
      return rows.map((e) => DepartmentModel.from_map(e)).toList();
    } catch (_) {
      final raw = await cache.read_string(key);
      if (raw != null) {
        final rows = List<Map<String, dynamic>>.from(decode_json(raw) as List);
        return rows.map((e) => DepartmentModel.from_map(e)).toList();
      }
      return local_ds.getDepartmentsByCollegeId(college_id);
    }
  }

  @override
  Future<List<ProgramModel>> getProgramsByUniversityId(int university_id) {
    return local_ds.getProgramsByUniversityId(university_id);
  }
}
