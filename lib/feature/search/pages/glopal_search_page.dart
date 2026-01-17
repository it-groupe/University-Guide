import 'package:flutter/material.dart';
import 'package:flutter_application_9/app/theme/widgets/app_scaffold.dart';

class GlopalSearchPage extends StatelessWidget {
  const GlopalSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      //
      title: 'البحث',
      body: Center(child: Text("صفحة البحث")),
    );
  }
}
