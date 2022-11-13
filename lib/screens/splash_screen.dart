import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:blogapp/screens/home_screen.dart';
import 'package:blogapp/screens/option_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final user = auth.currentUser;
    if (user != null) {
      Timer(
          Duration(seconds: 2),
          () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        useremail: auth.currentUser!.email.toString(),
                      ))));
    } else {
      Timer(
          Duration(seconds: 2),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => OptionScreen())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.network(
          'https://assets6.lottiefiles.com/private_files/lf30_dezgszkb.json',
          animate: true,
        ),
      ),
      //  Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      // children: [
      // Image(
      //   height: MediaQuery.of(context).size.height * .4,
      //   width: MediaQuery.of(context).size.width * .4,
      //   image: AssetImage('images/1200px-Blogger_Shiny_Icon.svg.png'),
      // ),
      // Padding(
      //   padding: const EdgeInsets.symmetric(vertical: 30),
      //   child: Align(
      //     alignment: Alignment.center,
      //     child: Text(
      //       'Blog!',
      //       style: TextStyle(
      //           fontStyle: FontStyle.italic,
      //           fontSize: 30,
      //           fontWeight: FontWeight.w300),
      //     ),
      //   ),
      // )
      // ],
      // ),
    );
  }
}
