import 'package:blogapp/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:blogapp/components/round_buttom.dart';
import 'package:blogapp/screens/signin.dart';
import 'package:lottie/lottie.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({Key? key}) : super(key: key);

  @override
  _OptionScreenState createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "Hello There!",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Automatic identity verification which enable you to verify your identity",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Lottie.network(
                height: 300,
                width: 400,
                'https://assets2.lottiefiles.com/packages/lf20_gjjlq5lu.json',
                animate: true,
              ),
              SizedBox(
                height: 50,
              ),
              RoundButton(
                title: 'Login',
                onPress: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              ),
              SizedBox(
                height: 30,
              ),
              RoundButton(
                title: 'Register',
                onPress: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
