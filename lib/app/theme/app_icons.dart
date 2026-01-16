import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// 🔒
/// يمنع استخدام Icon مباشرة داخل المشروع
/// استخدم AppIcons فقط
///
abstract class AppIcons {
  /* ---------------------------------
   *  🏠 عامة / تنقل
   * --------------------------------- */

  static const IconData home = EvaIcons.homeOutline;
  static const IconData search = EvaIcons.searchOutline;
  static const IconData back = EvaIcons.arrowBackOutline;
  static const IconData menu = EvaIcons.menu2Outline;
  static const IconData notifications = EvaIcons.bellOutline;

  /* ---------------------------------
   *  🎓 الدليل الجامعي
   * --------------------------------- */

  static final IconData college = MdiIcons.domain;
  static final IconData university = MdiIcons.schoolOutline;
  static final IconData department = MdiIcons.officeBuildingOutline;
  static final IconData major = MdiIcons.bookEducationOutline;

  /* ---------------------------------
   *  📚 محتوى أكاديمي
   * --------------------------------- */

  static final IconData subjects = EvaIcons.bookOpenOutline;
  static final IconData plan = MdiIcons.mapOutline;
  static final IconData schedule = EvaIcons.calendarOutline;
  static final IconData exam = MdiIcons.fileDocumentOutline;

  /* ---------------------------------
   *  👨‍🏫 أشخاص
   * --------------------------------- */

  static final IconData doctor = MdiIcons.accountTieOutline;
  static final IconData student = EvaIcons.personOutline;
  static final IconData group = EvaIcons.peopleOutline;

  /* ---------------------------------
   *  📍 مواقع ومرافق
   * --------------------------------- */

  static final IconData location = EvaIcons.pinOutline;
  static final IconData building = MdiIcons.officeBuilding;
  static final IconData lab = MdiIcons.flaskOutline;
  static final IconData library = MdiIcons.libraryOutline;

  /* ---------------------------------
   *  ⚙️ إعدادات
   * --------------------------------- */

  static final IconData settings = EvaIcons.settingsOutline;
  static final IconData help = EvaIcons.questionMarkCircleOutline;
  static final IconData info = EvaIcons.infoOutline;
  static final IconData logout = EvaIcons.logOutOutline;

  /* ---------------------------------
   *  🟢 حالات / Status
   * --------------------------------- */

  static final IconData success = EvaIcons.checkmarkCircle2Outline;
  static final IconData warning = EvaIcons.alertTriangleOutline;
  static final IconData error = EvaIcons.closeCircleOutline;

  /* ---------------------------------
   *  ➕ أفعال
   * --------------------------------- */

  static final IconData add = Icons.add;
  static final IconData edit = EvaIcons.editOutline;
  static final IconData delete = EvaIcons.trash2Outline;
  static final IconData share = EvaIcons.shareOutline;
}
