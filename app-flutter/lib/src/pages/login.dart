import 'package:flutter/material.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../constants/constants.dart';

class LoginPage extends HookWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();

    return Scaffold(
      backgroundColor: mainScaffoldBg,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Welcome',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black87),
              ),
            ),
            const Align(
              child: Text('Provide your email address to get started',
                  style: TextStyle(color: Colors.grey)),
              alignment: Alignment.center,
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.lightGreen),
                ),
                labelText: 'Email',
                prefixIcon: const Icon(FeatherIcons.mail),
                isDense: true,
                filled: true,
                fillColor: const Color(0xFFF0F0F0),
              ),
            ),
            const SizedBox(height: 20.0),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                      text: 'By signing in, you\'re agreeing to out '),
                  WidgetSpan(
                    child: InkWell(
                      onTap: () {},
                      child: const Text('Terms & Conditions',
                          style: TextStyle(color: Colors.lightGreen)),
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  WidgetSpan(
                    child: InkWell(
                      onTap: () {},
                      child: const Text('Privacy Policy',
                          style: TextStyle(color: Colors.lightGreen)),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Sign in'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50.0),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
