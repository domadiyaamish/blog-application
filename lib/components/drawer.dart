import 'package:blogapp/screens/aboutussecrren.dart';
import 'package:blogapp/screens/add_post.dart';
import 'package:blogapp/screens/home_screen.dart';
import 'package:blogapp/screens/login_screen.dart';
import 'package:blogapp/screens/myblogScreen.dart';
import 'package:blogapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DrawerDomadiya extends StatelessWidget {
  const DrawerDomadiya({
    super.key,
    required this.auth,
  });
  final dynamic auth;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(),
            child: Column(
              children: [
                Lottie.network(
                  height: 100,
                  width: 100,
                  'https://assets6.lottiefiles.com/private_files/lf30_dezgszkb.json',
                  animate: true,
                ),
                Text(
                  auth.currentUser!.email.toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Welcome'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    useremail: auth.currentUser!.email.toString(),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('About Us'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Aboutussecrren(
                    useremail: auth.currentUser!.email.toString(),
                  ),
                ),
              )
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('My Blog'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyblogScreen(
                    useremail: auth.currentUser!.email.toString(),
                  ),
                ),
              )
            },
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text('Add Blog'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPostScreen(
                      useremail: auth.currentUser!.email.toString(),
                    ),
                  ))
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () => {
              auth.signOut().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
              })
            },
          ),
        ],
      ),
    );
  }
}
