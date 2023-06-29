// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
import 'package:chatapp/Constants/color_constants.dart';
import 'package:chatapp/Constants/text_const.dart';
import 'package:chatapp/Screens/sign_up.dart';
import 'package:chatapp/Screens/users_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Api/apis.dart';
import '../Helper/dialogs.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});
  @override
  State<LogInPage> createState() => _LogInPageState();
}

Future<UserCredential?> _signInWithGoogle(BuildContext context) async {
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    return await APIs.auth.signInWithCredential(credential);
  } catch (e) {
    Dialogs().showSnackBar(context, "Something Went Wrong");
    return null;
  }
}

_handleBtnGoogleClick(BuildContext context) {
  Dialogs().showProgressBar(context);
  _signInWithGoogle(context).then((user) async => {
        Navigator.pop(context),
        if (user != null)
          {
            if (await APIs.isUserExist())
              {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => UserList()),
                )
              }
            else
              {
                await APIs.createUser()
                    .then((value) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => UserList()),
                        ))
              }
          }
      });
}

class _LogInPageState extends State<LogInPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const createAccount = "Create an account !";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Column(
          children: [
            Expanded(flex: 3, child: LogoImage()),
            Expanded(
              flex: 7,
              child: Container(
                color: Appcolors.bg,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      EmailView(emailController: _emailController),
                      PasswordView(passwordController: _passwordController),
                      SignUpButton(
                        context: context,
                        emailController: _emailController,
                        passwordController: _passwordController,
                      ),
                      GoggleButton(),
                      TextButtonField(createAccount: createAccount)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextButtonField extends StatelessWidget {
  const TextButtonField({
    super.key,
    required this.createAccount,
  });

  final String createAccount;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Text(
        createAccount,
        style: TextStyle(
            fontSize: 18,
            decoration: TextDecoration.underline,
            color: Colors.white),
      ),
    );
  }
}

class LogoImage extends StatelessWidget {
  const LogoImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Appcolors.bg,
        image: DecorationImage(
          image: AssetImage(RegisterConst.logoImage),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class PasswordView extends StatelessWidget {
  const PasswordView({
    super.key,
    required TextEditingController passwordController,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: TextField(
        controller: _passwordController,
        obscureText: true,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Color.fromARGB(255, 139, 71, 252),
            labelText: 'Password',
            labelStyle: TextStyle(color: Colors.white),
            prefixIcon: Icon(
              Icons.remove_red_eye,
              color: Colors.white,
            )),
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

class EmailView extends StatelessWidget {
  const EmailView({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextField(
        controller: _emailController,
        decoration: const InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(255, 139, 71, 252),
            border: OutlineInputBorder(),
            labelText: 'Email',
            labelStyle: TextStyle(color: Colors.white),
            prefixIcon: Icon(
              Icons.mail,
              color: Colors.white,
            )),
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

class GoggleButton extends StatelessWidget {
  const GoggleButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return SizedBox(
      width: mq.width * 0.8,
      height: 50,
      child: ElevatedButton.icon(
          onPressed: () {
            _handleBtnGoogleClick(context);
          },
          icon: Image.asset(RegisterConst.googleImage),
          label: const Text(RegisterConst.signInButtonText),
          style: ElevatedButton.styleFrom(
            backgroundColor: Appcolors.inputButtonBg,
          )),
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    super.key,
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  })  : _emailController = emailController,
        _passwordController = passwordController;

  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  void loginWithEmailPassword(
      String email, String password, BuildContext context) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    Dialogs().showProgressBar(context);
    if (userCredential.user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserList()),
      );
    } else {
      Dialogs().showSnackBar(context, "Email or Password Wrong !!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          width: mq.width * 0.8,
          height: 50,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Appcolors.inputButtonBg,
                  textStyle:
                      const TextStyle(fontSize: 18, color: Colors.white)),
              onPressed: () {
                loginWithEmailPassword(_emailController.text.toString(),
                    _passwordController.text.toString(), context);
              },
              child: const Text('Log In')),
        ));
  }
}
