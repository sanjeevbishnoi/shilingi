import 'package:flutter/material.dart';

import '../constants/constants.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainScaffoldBg,
        title: const Text('Login'),
      ),
      body: const Center(child: Text('login')),
    );
  }
}
