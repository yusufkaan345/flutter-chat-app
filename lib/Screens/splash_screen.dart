// ignore_for_file: prefer_const_constructors

import 'package:chatapp/Api/apis.dart';
import 'package:chatapp/Screens/sign_up.dart';
import 'package:chatapp/Screens/users_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Constants/text_const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 2000), () {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // transparent status bar
        systemNavigationBarColor: Colors.white,
      ));
      if (APIs.auth.currentUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => UserList()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => SignUpPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(flex: 5, child: LogoImage()),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.blue,
              child: const Center(
                child: Text(
                  'Welcome To Chit Chat 💜',
                  style: TextStyle(
                      fontSize: 34, color: Color.fromARGB(255, 205, 140, 212)),
                ),
              ),
            ),
          ),
        ],
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
