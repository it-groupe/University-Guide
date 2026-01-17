import 'package:flutter/material.dart';
import 'package:flutter_application_9/app/theme/widgets/app_scaffold.dart';

class TestLandingPage extends StatelessWidget {
  const TestLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      //
      title: 'الاختبار',
      body: Center(child: Text("صفحة الاختبار")),
    );
  }
}
