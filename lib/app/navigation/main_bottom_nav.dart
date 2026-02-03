import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_9/app/navigation/app_drawer.dart';
import 'package:flutter_application_9/app/theme/widgets/home_appbar_widget.dart';
import 'package:flutter_application_9/feature/auth/logic/auth_controller.dart';
import 'package:flutter_application_9/feature/auth/pages/login_page.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_icons.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

import 'package:flutter_application_9/feature/home/pages/home_dashboard_pate.dart';
import 'package:flutter_application_9/feature/profile/pages/profile_home_page.dart';
import 'package:flutter_application_9/feature/search/pages/glopal_search_page.dart';
import 'package:flutter_application_9/feature/test/pages/test_landing_page.dart';

class MainBottomNav extends StatefulWidget {
  const MainBottomNav({super.key});

  @override
  State<MainBottomNav> createState() => _MainBottomNavState();
}

class _MainBottomNavState extends State<MainBottomNav> {
  int _navIndex = 0;

  static const _titles = <String>['الرئيسية', 'بحث', 'اختبار', 'ملفي'];

  final _pages = const <Widget>[
    HomeDashboardPage(),
    GlopalSearchPage(),
    TestLandingPage(),
    ProfileHomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: AppColorScheme.mainbackgroun,

      drawer: AppDrawer(
        isGuest: auth.isGuest,
        userName: auth.displayName,

        onHomeTap: () => setState(() => _navIndex = 0),
        onSearchTap: () => setState(() => _navIndex = 1),

        onLoginTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        },

        onLogoutTap: () async {
          await context.read<AuthController>().logout();
        },
      ),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Builder(
          builder: (ctx) => HomeAppBar(
            title: _titles[_navIndex],
            onMenuTap: () => Scaffold.of(ctx).openDrawer(),
            onNotificationsTap: () {},
          ),
        ),
      ),

      // safeArea هنا لمنع تداخل البادنج الخاص بالـ AppBar مع البودّي
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
          decoration: const BoxDecoration(
            color: AppColorScheme.mainbackgroun,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -3),
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
    );
  }
}
