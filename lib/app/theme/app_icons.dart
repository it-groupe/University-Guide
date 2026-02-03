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

  static const IconData home = Icons.home_outlined;
  static const IconData search = Icons.search_outlined;
  static const IconData back = Icons.arrow_back;
  static const IconData menu = Icons.menu;
  static const IconData notifications = Icons.notifications_none;

  /* ---------------------------------
   *  🎓 الدليل الجامعي
   * --------------------------------- */

  static const IconData college = Icons.corporate_fare_rounded;
  static const IconData university = Icons.account_balance;
  static final IconData department = Icons.apartment;
  static final IconData major = Icons.school_outlined;

  /* ---------------------------------
   *  📚 محتوى أكاديمي
   * --------------------------------- */

  static final IconData subjects = Icons.menu_book_outlined;
  static final IconData plan = Icons.view_list_outlined;
  static final IconData schedule = Icons.schedule_outlined;
  static const IconData exam = Icons.document_scanner;

  /* ---------------------------------
   *  👨‍🏫 أشخاص
   * --------------------------------- */

  static final IconData doctor = MdiIcons.doctor;
  static const IconData student = Icons.person_pin;
  static final IconData group = Icons.group;

  /* ---------------------------------
   *  📍 مواقع ومرافق
   * --------------------------------- */

  static final IconData location = Icons.location_on_outlined;
  static final IconData building = MdiIcons.officeBuilding;
  static final IconData lab = MdiIcons.flaskOutline;
  static final IconData library = MdiIcons.libraryShelves;

  /* ---------------------------------
   *  ⚙️ إعدادات
   * --------------------------------- */

  static const IconData settings = EvaIcons.settingsOutline;
  static const IconData dark_mode = Icons.dark_mode_outlined;
  static const IconData help = EvaIcons.questionMarkCircleOutline;
  static const IconData info = EvaIcons.infoOutline;
  static const IconData logout = EvaIcons.logOutOutline;

  /* ---------------------------------
   *  🟢 حالات / Status
   * --------------------------------- */

  static final IconData success = Icons.check_circle_outlined;
  static const IconData warning = EvaIcons.alertTriangleOutline;
  static const IconData error = EvaIcons.closeCircleOutline;
  static const IconData favorite = Icons.favorite;
  static const IconData chevronleft = Icons.chevron_left;
  static const IconData test = Icons.note;

  /* ---------------------------------
   *  ➕ أفعال
   * --------------------------------- */

  static final IconData add = Icons.add;
  static final IconData edit = Icons.edit_outlined;
  static final IconData delete = Icons.delete_outlined;
  static final IconData share = MdiIcons.share;
}
