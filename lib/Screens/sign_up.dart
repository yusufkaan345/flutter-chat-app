// ignore_for_file: prefer_const_constructors
import 'package:chatapp/Constants/color_constants.dart';
import 'package:chatapp/Constants/text_const.dart';
import 'package:chatapp/Helper/dialogs.dart';
import 'package:chatapp/Screens/log_in.dart';
import 'package:chatapp/Screens/users_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Api/apis.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
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

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _userName;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _userName = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _userName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            Expanded(flex: 4, child: LogoImage()),
            Expanded(
              flex: 7,
              child: Container(
                color: Appcolors.bg,
                child: Column(
                  children: [
                    UserNameView(userName: _userName),
                    EmailView(emailController: _emailController),
                    PasswordView(passwordController: _passwordController),
                    SignUpButton(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      username: _userName,
                    ),
                    GoggleButton(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LogInPage()));
                      },
                      child: Text(
                        "Do you have an account?",
                        style: TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
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
      width: mq.width * 0.80,
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
        style: TextStyle(color: Colors.white),
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
            filled: true,
            fillColor: Appcolors.inputBg,
            border: OutlineInputBorder(),
            labelStyle: TextStyle(color: Colors.white),
            labelText: 'Password',
            prefixIcon: Icon(
              Icons.remove_red_eye,
              color: Colors.white,
            )),
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
          style: TextStyle(color: Colors.white),
          controller: _emailController,
          decoration: InputDecoration(
              filled: true,
              fillColor: Appcolors.inputBg,
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: Colors.white),
              labelText: 'Email',
              prefixIcon: Icon(
                Icons.mail,
                color: Colors.white,
              )),
        ));
  }
}

class UserNameView extends StatelessWidget {
  const UserNameView({
    super.key,
    required TextEditingController userName,
  }) : _userName = userName;

  final TextEditingController _userName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextField(
        style: TextStyle(color: Colors.white),
        controller: _userName,
        decoration: InputDecoration(
            filled: true,
            fillColor: Appcolors.inputBg,
            border: OutlineInputBorder(),
            labelStyle: TextStyle(color: Colors.white),
            labelText: 'Username',
            prefixIcon: Icon(
              Icons.person,
              color: Colors.white,
            )),
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton(
      {super.key,
      required TextEditingController emailController,
      required TextEditingController passwordController,
      required TextEditingController username})
      : _emailController = emailController,
        _passwordController = passwordController,
        _username = username;

  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final TextEditingController _username;

  void firebaseSignUp(BuildContext context) async {
    await APIs.auth.createUserWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
    if (await APIs.isUserExist()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => UserList()),
      );
    } else {
      await APIs.createUserCustom(
              _username.text.toString(), _emailController.text.toString())
          .then((value) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => UserList()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: SizedBox(
        width: mq.width * 0.80,
        height: 50,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Appcolors.inputButtonBg,
                textStyle: TextStyle(fontSize: 18, color: Colors.white)),
            onPressed: () => firebaseSignUp(context),
            child: Text('Sign Up')),
      ),
    );
  }
}
