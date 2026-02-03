import '../models/course_model.dart';
import '../models/program_model.dart';

class CoursesLocalMockDataSource {
  Future<List<ProgramModel>> get_programs() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return const [
      ProgramModel(
        program_id: 1,
        department_id: 10,
        name: 'علوم الحاسب',
        degree: 'Bachelor',
        duration_years: 4,
        description: 'برنامج يركز على البرمجة والخوارزميات وقواعد البيانات.',
      ),
      ProgramModel(
        program_id: 2,
        department_id: 10,
        name: 'تقنية المعلومات',
        degree: 'Bachelor',
        duration_years: 4,
        description: 'برنامج يركز على الشبكات والأنظمة وأمن المعلومات.',
      ),
    ];
  }

  Future<List<CourseModel>> get_courses_catalog() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return const [
      CourseModel(
        course_id: 1,
        program_id: 1,
        name: 'مقدمة في البرمجة',
        code: 'CS101',
        credit_hours: 3,
        description: 'أساسيات البرمجة + المتغيرات + الشروط + الحلقات.',
      ),
      CourseModel(
        course_id: 2,
        program_id: 1,
        name: 'هياكل البيانات',
        code: 'CS201',
        credit_hours: 3,
        description: 'قوائم، مكدسات، طوابير، أشجار، خرائط.',
      ),
      CourseModel(
        course_id: 3,
        program_id: 2,
        name: 'شبكات الحاسب',
        code: 'IT210',
        credit_hours: 3,
        description: 'مفاهيم الشبكات + TCP/IP + أجهزة الشبكات.',
      ),
      CourseModel(
        course_id: 4,
        program_id: 2,
        name: 'أمن المعلومات',
        code: 'IT320',
        credit_hours: 3,
        description: 'أساسيات الأمن + التشفير + الممارسات الآمنة.',
      ),
    ];
  }
}
