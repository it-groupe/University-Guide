class ApiEndpoints {
  //حق الايموليتر
  static const String base_url = 'http://10.0.2.2/university_guide_api';

  // للجامعات
  static const String universities_list = '/universities/list.php';
  static const String colleges = '/universities/colleges.php';
  static const String departments = '/universities/departments.php';
  static const String programs = '/universities/programs.php';

  // Auth
  static const String auth_register = '/auth/register.php';
  static const String auth_login = '/auth/login.php';
}
