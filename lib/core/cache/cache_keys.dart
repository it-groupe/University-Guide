class CacheKeys {
  static const String universities_list = 'cache_universities_list';
  static String colleges(int university_id) =>
      'cache_colleges_u_$university_id';
  static String departments(int college_id) =>
      'cache_departments_c_$college_id';
  static String programs(int department_id) =>
      'cache_programs_d_$department_id';

  static const String auth_user = 'cache_auth_user';
}
