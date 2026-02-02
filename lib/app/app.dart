import 'package:flutter/material.dart';
import 'package:flutter_application_9/feature/profile/data/datasource/profile_local_mock_ds.dart';
import 'package:flutter_application_9/feature/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_application_9/feature/test/logic/tests_controller.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_9/app/navigation/main_bottom_nav.dart';
import 'package:flutter_application_9/app/theme/app_theme.dart';

import 'package:flutter_application_9/feature/profile/data/repositories/profile_repository.dart';
import 'package:flutter_application_9/feature/profile/logic/profile_controller.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainBottomNav(),
      ),
    );
  }
}
