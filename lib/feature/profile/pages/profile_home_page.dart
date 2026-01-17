import 'package:flutter/material.dart';
import 'package:flutter_application_9/app/theme/widgets/app_scaffold.dart';

class ProfileHomePage extends StatelessWidget {
  const ProfileHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      //
      title: 'ملفي',
      body: Center(child: Text("صفحة ملفي")),
    );
  }
}
