import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class AuthorizePage extends StatelessWidget {
  const AuthorizePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: mainScaffoldBg,
      body: Center(
        child: Text('Authorize'),
      ),
    );
  }
}
