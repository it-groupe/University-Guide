import 'package:flutter/material.dart';
import 'package:flutter_application_9/app/theme/widgets/app_scaffold.dart';
import 'package:flutter_application_9/app/theme/widgets/home_appbar_widget.dart';
import 'package:flutter_application_9/feature/home/pages/home_dashboard_pate.dart';
import 'package:flutter_application_9/feature/profile/pages/profile_home_page.dart';
import 'package:flutter_application_9/feature/search/pages/glopal_search_page.dart';
import 'package:flutter_application_9/feature/test/pages/test_landing_page.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_icons.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class MainBottomNav extends StatefulWidget {
  const MainBottomNav({super.key});

  @override
  State<MainBottomNav> createState() => _MainBottomNav();
}

class _MainBottomNav extends State<MainBottomNav> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _navIndex = 0;

  static const _titles = <String>['الرئيسية', 'بحث', 'اختبار', 'ملفي'];

  final _pages = const <Widget>[
    HomeDashboardPage(),
    TestLandingPage(),
    GlopalSearchPage(),
    ProfileHomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      key: _scaffoldKey,
      title: _titles[_navIndex],

      appBar: HomeAppBar(
        title: _titles[_navIndex],
        onMenuTap: () => _scaffoldKey.currentState?.openEndDrawer(),
        onNotificationsTap: () {},
      ),

      body: SafeArea(
        top: false,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: IndexedStack(index: _navIndex, children: _pages),
        ),
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          //  خلفية كاملة للبار
          color: AppColorScheme.mainbackgroun,

          // ظل خفيف
          child: Container(
            decoration: const BoxDecoration(
              color: AppColorScheme.mainbackgroun,

              boxShadow: [
                BoxShadow(
                  //
                  color: Colors.black12,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: BottomNavigationBar(
                currentIndex: _navIndex,
                onTap: (i) => setState(() => _navIndex = i),
                type: BottomNavigationBarType.fixed,

                backgroundColor: AppColorScheme.mainbackgroun,
                elevation: 0,

                selectedItemColor: AppColorScheme.brandPrimary,
                unselectedItemColor: AppColorScheme.textDisabled,
                selectedLabelStyle: AppTextStyles.label,
                unselectedLabelStyle: AppTextStyles.label,

                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(AppIcons.home),
                    label: 'الرئيسية',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(AppIcons.search),
                    label: 'بحث',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(AppIcons.exam),
                    label: 'اختبار',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(AppIcons.student),
                    label: 'ملفي',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
