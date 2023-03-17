import 'dart:io';

import 'package:chatapp/Constants/register_const.dart';
import 'package:chatapp/Screens/users_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _userName;
  File? _image;

  Future pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    File? img = File(image.path);
    setState(() {
      _image = img;
    });
  }

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
            Expanded(flex: 3, child: LogoImage()),
            Expanded(
              flex: 7,
              child: Container(
                color: Colors.blue,
                child: Column(
                  children: [
                    PhotoPicker(),
                    UserNameView(userName: _userName),
                    EmailView(emailController: _emailController),
                    PasswordView(passwordController: _passwordController),
                    SignUpButton(
                        emailController: _emailController,
                        passwordController: _passwordController)
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

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    super.key,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  })  : _emailController = emailController,
        _passwordController = passwordController;

  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          width: 150,
          height: 50,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  textStyle:
                      const TextStyle(fontSize: 18, color: Colors.white)),
              onPressed: () async {
                FirebaseAuth auth = FirebaseAuth.instance;

                await auth
                    .createUserWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text)
                    .then((value) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserList())));
              },
              child: const Text('Sign Up')),
        ));
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
            fillColor: Color.fromARGB(255, 173, 123, 233),
            labelText: 'Password',
            prefixIcon: Icon(Icons.remove_red_eye)),
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
            fillColor: Color.fromARGB(255, 173, 123, 233),
            border: OutlineInputBorder(),
            labelText: 'Email',
            prefixIcon: Icon(Icons.mail)),
      ),
    );
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextField(
        controller: _userName,
        decoration: const InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(255, 173, 123, 233),
            border: OutlineInputBorder(),
            labelText: 'UserName',
            prefixIcon: Icon(Icons.person)),
      ),
    );
  }
}

class PhotoPicker extends StatelessWidget {
  const PhotoPicker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          // İnkwel ile tıklama işlemleri
        },
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
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
      decoration: const BoxDecoration(
        color: Colors.blue,
        image: DecorationImage(
          image: AssetImage(RegisterConst.logoImage),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
