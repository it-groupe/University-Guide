import 'package:flutter/material.dart';
import 'package:flutter_application_9/feature/auth/logic/auth_controller.dart';
import 'package:flutter_application_9/feature/auth/pages/login_page.dart';
import 'package:flutter_application_9/feature/profile/data/datasource/profile_local_mock_ds.dart';
import 'package:flutter_application_9/feature/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_application_9/feature/services/cources/data/datasources/courses_local_mock_ds.dart';
import 'package:flutter_application_9/feature/services/cources/data/repositories/courses_repository.dart';
import 'package:flutter_application_9/feature/services/cources/data/repositories/courses_repository_impl.dart';
import 'package:flutter_application_9/feature/services/cources/logic/courses_controller.dart';
import 'package:flutter_application_9/feature/services/universities/data/dataSources/universities_local_mock_ds.dart';
import 'package:flutter_application_9/feature/services/universities/data/repositories/universities_repository.dart';
import 'package:flutter_application_9/feature/services/universities/data/repositories/universities_repository_impl.dart';
import 'package:flutter_application_9/feature/services/universities/logic/universities_controller.dart';
import 'package:flutter_application_9/feature/test/logic/tests_controller.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_9/app/theme/app_theme.dart';
import 'package:flutter_application_9/app/theme/app_theme_controller.dart';

import 'package:flutter_application_9/feature/profile/data/repositories/profile_repository.dart';
import 'package:flutter_application_9/feature/profile/logic/profile_controller.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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

        ChangeNotifierProvider<AuthController>(create: (_) => AuthController()),

        ChangeNotifierProvider<ThemeController>(
          create: (_) => ThemeController(),
        ),
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

        ChangeNotifierProvider<TestsController>(
          create: (_) => TestsController(),
        ),

        Provider<UniversitiesLocalMockDataSource>(
          create: (_) => UniversitiesLocalMockDataSource(),
        ),
        Provider<UniversitiesRepository>(
          create: (context) => UniversitiesRepositoryImpl(
            ds: context.read<UniversitiesLocalMockDataSource>(),
          ),
        ),
        ChangeNotifierProvider<UniversitiesController>(
          create: (context) =>
              UniversitiesController(context.read<UniversitiesRepository>()),
        ),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeCtrl, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeCtrl.theme_mode,
            home: const LoginPage(),
          );
        },
      ),
    );
  }
}
