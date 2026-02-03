import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_9/app/navigation/main_bottom_nav.dart';
import 'package:flutter_application_9/app/theme/app_theme.dart';
import 'package:flutter_application_9/app/theme/app_theme_controller.dart';

import 'package:flutter_application_9/feature/auth/logic/auth_controller.dart';
import 'package:flutter_application_9/feature/auth/pages/login_page.dart';

import 'package:flutter_application_9/feature/profile/data/datasource/profile_local_mock_ds.dart';
import 'package:flutter_application_9/feature/profile/data/repositories/profile_repository.dart';
import 'package:flutter_application_9/feature/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_application_9/feature/profile/logic/profile_controller.dart';

import 'package:flutter_application_9/feature/test/logic/tests_controller.dart';

import 'package:flutter_application_9/feature/services/cources/data/datasources/courses_local_mock_ds.dart';
import 'package:flutter_application_9/feature/services/cources/data/repositories/courses_repository.dart';
import 'package:flutter_application_9/feature/services/cources/data/repositories/courses_repository_impl.dart';
import 'package:flutter_application_9/feature/services/cources/logic/courses_controller.dart';

import 'package:flutter_application_9/feature/services/universities/data/dataSources/universities_local_mock_ds.dart';
import 'package:flutter_application_9/feature/services/universities/data/dataSources/universities_remote_ds.dart';
import 'package:flutter_application_9/feature/services/universities/data/repositories/universities_repository.dart';
import 'package:flutter_application_9/feature/services/universities/data/repositories/universities_repository_impl.dart';
import 'package:flutter_application_9/feature/services/universities/logic/universities_controller.dart';

import 'package:flutter_application_9/core/network/api_client.dart';
import 'package:flutter_application_9/core/cache/cache_store.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Core
        Provider<ApiClient>(create: (_) => ApiClient()),
        Provider<CacheStore>(create: (_) => CacheStore()),

        // ✅ Theme (كان ناقص)
        ChangeNotifierProvider<ThemeController>(
          create: (_) => ThemeController(),
        ),

        // Courses (mock)
        Provider<CoursesLocalMockDataSource>(
          create: (_) => CoursesLocalMockDataSource(),
        ),
        Provider<CoursesRepository>(
          create: (context) => CoursesRepositoryImpl(
            localDs: context.read<CoursesLocalMockDataSource>(),
          ),
        ),
        ChangeNotifierProvider<CoursesController>(
          create: (context) =>
              CoursesController(context.read<CoursesRepository>()),
        ),

        // Auth
        ChangeNotifierProvider<AuthController>(
          create: (context) => AuthController(
            api: context.read<ApiClient>(),
            cache: context.read<CacheStore>(),
          )..load_session(),
        ),

        // Profile (mock)
        Provider<ProfileLocalMockDataSource>(
          create: (_) => ProfileLocalMockDataSource(),
        ),
        Provider<ProfileRepository>(
          create: (context) => ProfileRepositoryImpl(
            mockDs: context.read<ProfileLocalMockDataSource>(),
          ),
        ),
        ChangeNotifierProvider<ProfileController>(
          create: (context) =>
              ProfileController(context.read<ProfileRepository>())..load(),
        ),

        // Test (sqlite)
        ChangeNotifierProvider<TestsController>(
          create: (_) => TestsController(),
        ),

        // Universities (remote + cache + local fallback)
        Provider<UniversitiesLocalMockDataSource>(
          create: (_) => UniversitiesLocalMockDataSource(),
        ),
        Provider<UniversitiesRemoteDataSource>(
          create: (context) =>
              UniversitiesRemoteDataSource(api: context.read<ApiClient>()),
        ),
        Provider<UniversitiesRepository>(
          create: (context) => UniversitiesRepositoryImpl(
            local_ds: context.read<UniversitiesLocalMockDataSource>(),
            remote_ds: context.read<UniversitiesRemoteDataSource>(),
            cache: context.read<CacheStore>(),
          ),
        ),
        ChangeNotifierProvider<UniversitiesController>(
          create: (context) =>
              UniversitiesController(context.read<UniversitiesRepository>()),
        ),
      ],

      // ✅ builder: أفضل من child Consumer لتجنب ProviderNotFound بسبب context
      builder: (context, _) {
        final themeCtrl = context.watch<ThemeController>();
        final auth = context.watch<AuthController>();

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeCtrl.theme_mode,

          // ✅ لو مسجل دخول (أو ضيف) ادخله للـ MainBottomNav
          home: auth.isLoggedIn ? const MainBottomNav() : const LoginPage(),
        );
      },
    );
  }
}
