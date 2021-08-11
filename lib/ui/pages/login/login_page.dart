import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: ListView(
        padding: EdgeInsets.all(32),
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            child: Image.asset('lib/ui/assets/logo.png'),
          ),
          Text('Login'.toUpperCase()),
          SizedBox(height: 8),
          TextFormField(),
          SizedBox(height: 8),
          TextFormField(),
          SizedBox(height: 16),
          TextButton(onPressed: () {}, child: Text('Entrar')),
          SizedBox(height: 8),
          TextButton(onPressed: () {}, child: Text('Criar Conta')),
        ],
      ),
    );
  }
}
