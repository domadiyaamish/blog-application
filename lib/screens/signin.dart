import 'package:blogapp/components/round_buttom.dart';
import 'package:blogapp/screens/db_service.dart';
import 'package:blogapp/screens/login_screen.dart';
import 'package:blogapp/services/blog_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import 'home_screen.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController copasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String email = "", password = "", copassword = "";
  @override
  Widget build(BuildContext context) {
    // return ModalProgressHUD(
    //   inAsyncCall: showSpinner,
    //   child:
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Account'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.network(
                  height: 200,
                  width: 300,
                  'https://assets2.lottiefiles.com/packages/lf20_hzgq1iov.json',
                  animate: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                hintText: 'Email',
                                labelText: 'email',
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder()),
                            onChanged: (String value) {
                              email = value;
                            },
                            validator: (value) {
                              return value!.isEmpty ? 'enter email' : null;
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: TextFormField(
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: 'Password',
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock),
                                  border: OutlineInputBorder()),
                              onChanged: (String value) {
                                password = value;
                              },
                              validator: (value) {
                                return value!.isEmpty ? 'enter Password' : null;
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: TextFormField(
                              controller: copasswordController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: 'Co Password',
                                  labelText: 'Co Password',
                                  prefixIcon: Icon(Icons.lock),
                                  border: OutlineInputBorder()),
                              onChanged: (String value) {
                                copassword = value;
                              },
                              validator: (value) {
                                return value!.isEmpty
                                    ? 'enter Co Password'
                                    : null;
                              }),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 18,
                                    color: Color(0xff4c505b),
                                  ),
                                )),
                          ],
                        ),
                        RoundButton(
                            title: 'Register',
                            onPress: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  showSpinner = true;
                                });
                                try {
                                  if (password == copassword) {
                                    final user = await _auth
                                        .createUserWithEmailAndPassword(
                                            email: email.toString().trim(),
                                            password:
                                                password.toString().trim());
                                    if (user != null) {
                                      print('sucess');
                                      toastMessage("User sucessfully created");
                                      BlogService blogService = BlogService(
                                          uid: _auth.currentUser!.uid);
                                      blogService.insertDummy();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomeScreen(
                                                    useremail: '',
                                                  )));
                                      setState(() {
                                        showSpinner = false;
                                      });
                                    }
                                  } else {
                                    print('pass not match');
                                    toastMessage("User password do not match");
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  }
                                } catch (e) {
                                  print(e.toString());
                                  toastMessage(e.toString());
                                  setState(() {
                                    showSpinner = false;
                                  });
                                }
                              }
                            })
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
    // );
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
