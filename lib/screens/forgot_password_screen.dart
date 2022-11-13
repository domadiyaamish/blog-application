import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import '../components/round_buttom.dart';
import 'home_screen.dart';

class ForgotPasswordscreen extends StatefulWidget {
  const ForgotPasswordscreen({super.key});

  @override
  State<ForgotPasswordscreen> createState() => _ForgotPasswordscreenState();
}

class _ForgotPasswordscreenState extends State<ForgotPasswordscreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  TextEditingController emailController = TextEditingController();

  Future passwordReset() async {
    try {
      print(emailController.text);
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: "domadiyaamish@gmail.com");
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Password reset link sent! check your email'),
          );
        },
      );
    }
  }

  final _formKey = GlobalKey<FormState>();
  String email = "";
  @override
  Widget build(BuildContext context) {
    // return ModalProgressHUD(
    //   inAsyncCall: showSpinner,
    //   child:
    return Scaffold(
        appBar: AppBar(
          title: Text('Forgot Password'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Forgot Password',
                  style: TextStyle(fontSize: 35),
                ),
                Lottie.network(
                  height: 300,
                  width: 400,
                  'https://assets1.lottiefiles.com/packages/lf20_mdhnmscc.json',
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
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: RoundButton(
                            title: 'Recover Password',
                            onPress: () => passwordReset(),
                            //  () async {
                            //   if (_formKey.currentState!.validate()) {
                            //     setState(() {
                            //       showSpinner = true;
                            //     });
                            //     try {
                            //       print(emailController.text);
                            //       _auth
                            //           .sendPasswordResetEmail(
                            //               email: emailController.text
                            //                   .toString()
                            //                   .trim())
                            //           .then((value) {
                            //         setState(() {
                            //           showSpinner = false;
                            //         });
                            //         toastMessage(
                            //             'please check your email,a reset link sent to you via email');
                            //       }).onError((error, stackTrace) {
                            //         toastMessage(error.toString());
                            //         setState(() {
                            //           showSpinner = false;
                            //         });
                            //       });
                            //     } catch (e) {
                            //       print(e.toString());
                            //       toastMessage(e.toString());
                            //       setState(() {
                            //         showSpinner = false;
                            //       });
                            //     }
                            //   }
                            // }),
                          ),
                        )
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
