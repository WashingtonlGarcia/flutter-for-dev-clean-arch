import 'package:flutter/material.dart';
import 'pages/login/login_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '4Dev',
      home: LoginPage(),
    );
  }
}
