import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants/constants.dart';

class RegistrationPage extends HookWidget {
  const RegistrationPage({Key? key}) : super(key: key);

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
    final creatingValue = useState<bool>(false);
    final passwordVisible = useState<bool>(false);

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
                  child: Text(
                    'Provide your email address and password to get started',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
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
                  onPressed: text.isNotEmpty &&
                          emailIsValid &&
                          password.isNotEmpty &&
                          !creatingValue.value
                      ? () async {
                          creatingValue.value = true;
                          try {
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: text,
                              password: password,
                            );
                            error.value = null;
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              error.value =
                                  ('The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
                              error.value =
                                  'The account already exists for that email.';
                            }
                          } catch (e) {
                            var snackBar = const SnackBar(
                              content: Text(
                                  'Something unexpected happened. Kindly try again later'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                          creatingValue.value = false;
                        }
                      : null,
                  child:
                      Text(creatingValue.value ? 'Registering...' : 'Register'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50.0),
                    elevation: 0,
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
