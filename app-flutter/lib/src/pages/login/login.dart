import 'package:flutter/material.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants/constants.dart';

class LoginPage extends HookWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    final textValue = useState<String>('');
    final emailValidValue = useState<bool>(false);
    textController.addListener(() {
      textValue.value = textController.text;
      emailValidValue.value = EmailValidator.validate(textValue.value);
    });
    final text = textValue.value;
    final emailIsValid = emailValidValue.value;

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
              keyboardType: TextInputType.emailAddress,
              controller: textController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: text.isEmpty ? Colors.transparent : Colors.grey),
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
              onPressed: text.isNotEmpty && emailIsValid
                  ? () {
                      final acs = ActionCodeSettings(
                        url: 'https://app.shillingi.app/authorize',
                        handleCodeInApp: true,
                        iOSBundleId: 'com.example.shilingi',
                        androidPackageName: 'com.example.shilingi',
                        androidInstallApp: true,
                        androidMinimumVersion: '12',
                      );
                      FirebaseAuth.instance
                          .sendSignInLinkToEmail(
                              email: text, actionCodeSettings: acs)
                          .then((value) {
                        var snackBar = const SnackBar(
                          content: Text('Successfully sent email verification'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        textController.text = '';
                      }, onError: (err) {
                        print('error $err');
                        var snackBar = const SnackBar(
                          content: Text(
                              'Error sending email verification, kindly try again.'),
                          backgroundColor: Colors.redAccent,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    }
                  : null,
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
