import 'package:flutter_application_9/core/network/api_client.dart';
import 'package:flutter_application_9/core/network/api_endpoints.dart';

class UniversitiesRemoteDataSource {
  final ApiClient api;

  UniversitiesRemoteDataSource({required this.api});

  Future<List<Map<String, dynamic>>> getUniversities() async {
    final res = await api.get_json(
      '${ApiEndpoints.base_url}${ApiEndpoints.universities_list}',
    );
    return List<Map<String, dynamic>>.from(res['data'] as List);
  }

  Future<List<Map<String, dynamic>>> getCollegesByUniversityId(
    int university_id,
  ) async {
    final res = await api.get_json(
      '${ApiEndpoints.base_url}${ApiEndpoints.colleges}',
      query: {'university_id': '$university_id'},
    );
    return List<Map<String, dynamic>>.from(res['data'] as List);
  }

  Future<List<Map<String, dynamic>>> getDepartmentsByCollegeId(
    int college_id,
  ) async {
    final res = await api.get_json(
      '${ApiEndpoints.base_url}${ApiEndpoints.departments}',
      query: {'college_id': '$college_id'},
    );
    return List<Map<String, dynamic>>.from(res['data'] as List);
  }
}
