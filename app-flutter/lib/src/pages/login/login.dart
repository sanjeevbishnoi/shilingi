import 'package:flutter/material.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants/constants.dart';
import './routepath.dart';

class LoginPage extends HookWidget {
  const LoginPage({Key? key, required this.goTo}) : super(key: key);

  final ValueChanged<LoginRoute> goTo;

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

    final passwordController = useTextEditingController();
    final passwordValue = useState<String>('');
    final password = passwordValue.value;
    passwordController.addListener(() {
      passwordValue.value = passwordController.text;
    });

    final passwordVisible = useState<bool>(false);

    final signingIn = useState<bool>(false);

    final error = useState<String?>(null);

    return Scaffold(
      backgroundColor: mainScaffoldBg,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
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
                if (error.value != null) ...[
                  LayoutBuilder(builder: (context, constraints) {
                    return Container(
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Text(error.value!),
                    );
                  }),
                  const SizedBox(height: 20.0),
                ],
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: textController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color:
                              text.isEmpty ? Colors.transparent : Colors.grey),
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
                TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !passwordVisible.value,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color: password.isEmpty
                              ? Colors.transparent
                              : Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.lightGreen),
                    ),
                    labelText: 'Password',
                    prefixIcon: const Icon(FeatherIcons.lock),
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xFFF0F0F0),
                    suffixIcon: InkWell(
                      onTap: () {
                        passwordVisible.value = !passwordVisible.value;
                      },
                      child: Icon(passwordVisible.value
                          ? FeatherIcons.eye
                          : FeatherIcons.eyeOff),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: text.isNotEmpty &&
                          emailIsValid &&
                          password.isNotEmpty &&
                          !signingIn.value
                      ? () async {
                          signingIn.value = true;
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: text, password: password);
                            error.value = null;
                          } on FirebaseAuthException catch (_) {
                            error.value =
                                'Invalid username/password combination';
                          }
                          signingIn.value = false;
                        }
                      : null,
                  child: Text(signingIn.value ? 'Signing in...' : 'Sign in'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50.0),
                    elevation: 0,
                  ),
                ),
                const SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: 'New to Shillingi? '),
                        WidgetSpan(
                          child: InkWell(
                            onTap: () {
                              goTo(LoginRoute.register);
                            },
                            child: const Text(
                              'Create an account',
                              style: TextStyle(color: Colors.lightGreen),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}