import 'package:blogapp/screens/add_post.dart';
import 'package:blogapp/screens/home_screen.dart';
import 'package:blogapp/screens/login_screen.dart';
import 'package:blogapp/screens/myblogScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../components/drawer.dart';

class Aboutussecrren extends StatefulWidget {
  const Aboutussecrren({Key? key, required this.useremail}) : super(key: key);

  final String useremail;

  @override
  State<Aboutussecrren> createState() => _AboutussecrrenState(useremail);
}

class _AboutussecrrenState extends State<Aboutussecrren> {
  String useremail;
  _AboutussecrrenState(this.useremail);
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
          backgroundColor: Color(0xfff9fafc),
          appBar: AppBar(
            title: Text('Blogs'),
            centerTitle: true,
          ),
          drawer: DrawerDomadiya(
            auth: auth,
          ),
          body: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "About Us",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "But we know there's a better way to grow. One where what's good for the bottom line is also good for customers. We believe businesses can grow with a conscience, and succeed with a soul — and that they can do it with inbound. That's why we've created an ecosystem uniting software, education, and community to help businesses grow better every day.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                ),
              )
            ],
          )),
    );
  }
}
