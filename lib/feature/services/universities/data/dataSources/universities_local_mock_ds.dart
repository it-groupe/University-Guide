import '../models/university_model.dart';
import '../models/college_model.dart';
import '../models/department_model.dart';
import '../models/program_model.dart';

class UniversitiesLocalMockDataSource {
  Future<List<UniversityModel>> getUniversities() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return const [
      UniversityModel(
        university_id: 1,
        name: 'جامعة ذمار',
        description: 'جامعة محلية تقدم برامج متنوعة في عدة كليات.',
        logo_path: 'assets/universities/913552722161563.jpg',
        website: 'assets/universities/913552722161563.jpg',
        created_at: '2026-01-01',
      ),
      UniversityModel(
        university_id: 2,
        name: 'جامعة صنعاء',
        description: 'من أقدم الجامعات وتضم تخصصات متعددة.',
        logo_path: 'assets/universities/Sana\'a_New_University.jpeg',
        website: 'assets/universities/Sana\'a_New_University.jpeg',
        created_at: '2026-01-01',
      ),
    ];
  }

  Future<List<CollegeModel>> getCollegesByUniversityId(
    int university_id,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    const colleges = <CollegeModel>[
      // جامعة ذمار (1)
      CollegeModel(
        college_id: 1,
        university_id: 1,
        name: 'كلية الحاسوب',
        description: 'برامج وتقنيات الحاسوب ونظم المعلومات.',
        image_path: 'assets/universities/college_cs.png',
      ),
      CollegeModel(
        college_id: 2,
        university_id: 1,
        name: 'كلية الهندسة',
        description: 'تخصصات هندسية متعددة.',
        image_path: 'assets/universities/college_eng.png',
      ),

      // جامعة صنعاء (2)
      CollegeModel(
        college_id: 3,
        university_id: 2,
        name: 'كلية الحاسوب',
        description: 'برامج حوسبة وشبكات وأمن سيبراني.',
        image_path: 'assets/universities/college_cs.png',
      ),
      CollegeModel(
        college_id: 4,
        university_id: 2,
        name: 'كلية العلوم',
        description: 'تخصصات علمية متنوعة.',
        image_path: 'assets/universities/college_sci.png',
      ),
    ];

    return colleges.where((c) => c.university_id == university_id).toList();
  }

  Future<List<DepartmentModel>> getDepartmentsByCollegeId(
    int college_id,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));

    const deps = <DepartmentModel>[
      DepartmentModel(
        department_id: 1,
        college_id: 1,
        name: 'قسم نظم المعلومات',
        description: 'تحليل وتصميم نظم المعلومات.',
      ),
      DepartmentModel(
        department_id: 2,
        college_id: 1,
        name: 'قسم علوم الحاسوب',
        description: 'خوارزميات، برمجة، ذكاء اصطناعي.',
      ),
      DepartmentModel(
        department_id: 3,
        college_id: 2,
        name: 'قسم الهندسة المدنية',
        description: 'تصميم وتنفيذ المشاريع.',
      ),
      DepartmentModel(
        department_id: 4,
        college_id: 2,
        name: 'قسم الهندسة المعمارية',
        description: 'تصميم معماري وإبداع.',
      ),

      DepartmentModel(
        department_id: 5,
        college_id: 3,
        name: 'قسم شبكات',
        description: 'شبكات وأمن.',
      ),
      DepartmentModel(
        department_id: 6,
        college_id: 4,
        name: 'قسم أحياء',
        description: 'علوم الحياة.',
      ),
    ];

    return deps.where((d) => d.college_id == college_id).toList();
  }

  Future<List<ProgramModel>> getProgramsByUniversityId(
    int university_id,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // لاحقاً: هذا يجي من join program->department->college->university
    // هنا بنبسطها بمعلومات Mock
    const programs = <ProgramModel>[
      // برامج مرتبطة بأقسام كلية الحاسوب (جامعة ذمار)
      ProgramModel(
        program_id: 1,
        department_id: 1,
        name: 'نظم معلومات',
        degree: 'بكالوريوس',
        duration_years: 4,
        description: 'تحليل نظم، قواعد بيانات، نظم مؤسسية.',
      ),
      ProgramModel(
        program_id: 2,
        department_id: 2,
        name: 'علوم حاسوب',
        degree: 'بكالوريوس',
        duration_years: 4,
        description: 'برمجة، خوارزميات، ذكاء اصطناعي.',
      ),

      // جامعة صنعاء (مثال)
      ProgramModel(
        program_id: 3,
        department_id: 5,
        name: 'شبكات وأمن سيبراني',
        degree: 'بكالوريوس',
        duration_years: 4,
        description: 'شبكات، أمن، أنظمة.',
      ),
      ProgramModel(
        program_id: 4,
        department_id: 6,
        name: 'أحياء',
        degree: 'بكالوريوس',
        duration_years: 4,
        description: 'علوم حياتية أساسية وتطبيقية.',
      ),
    ];

    // نحدد جامعة ذمار: departments 1,2,3,4 (في mock)
    // جامعة صنعاء: departments 5,6
    final allowedDeptIds = university_id == 1 ? {1, 2, 3, 4} : {5, 6};

    return programs
        .where((p) => allowedDeptIds.contains(p.department_id))
        .toList();
  }
}
