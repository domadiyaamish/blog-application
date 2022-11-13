import 'dart:io';

import 'package:blogapp/components/round_buttom.dart';
import 'package:blogapp/screens/aboutussecrren.dart';
import 'package:blogapp/screens/db_service.dart';
import 'package:blogapp/screens/home_screen.dart';
import 'package:blogapp/screens/login_screen.dart';
import 'package:blogapp/screens/myblogScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firbase_storage;
import 'package:firebase_database/firebase_database.dart';

import '../components/drawer.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key, required this.useremail}) : super(key: key);

  final String useremail;
  @override
  State<AddPostScreen> createState() => _AddPostScreenState(useremail);
}

class _AddPostScreenState extends State<AddPostScreen> {
  String useremail;
  _AddPostScreenState(this.useremail);
  bool showSpinner = false;
  final postRef = FirebaseDatabase.instance.reference().child('Posts');
  firbase_storage.FirebaseStorage storage =
      firbase_storage.FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseAuth _auth = FirebaseAuth.instance;
  File? _image;
  final picker = ImagePicker();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController autherController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  Future getImageGallery() async {
    final PickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
      } else {
        print('No image selected');
      }
    });
  }

  Future getCameraImage() async {
    final PickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
      } else {
        print('No image selected');
      }
    });
  }

  void dialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      getCameraImage();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.camera),
                      title: Text('Camera'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getImageGallery();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Gallery'),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Upload Blogs'),
          centerTitle: true,
          actions: [],
        ),
        drawer: DrawerDomadiya(
          auth: auth,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    dialog(context);
                  },
                  child: Center(
                    child: Container(
                        height: MediaQuery.of(context).size.height * .2,
                        width: MediaQuery.of(context).size.width * .2,
                        child: _image != null
                            ? ClipRect(
                                child: Image.file(
                                  _image!.absolute,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(10)),
                                width: 100,
                                height: 100,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.blue,
                                ),
                              )),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Title',
                            hintText: 'Enter a post title',
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal)),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: autherController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Auther',
                            hintText: 'Enter your name',
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal)),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        keyboardType: TextInputType.text,
                        minLines: 1,
                        maxLines: 10,
                        decoration: InputDecoration(
                            labelText: 'Description',
                            hintText: 'Enter a post Description',
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal)),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: linkController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Link',
                            hintText: 'Enter a post Link',
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                RoundButton(
                    title: 'Upload',
                    onPress: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        int date = DateTime.now().microsecondsSinceEpoch;
                        firbase_storage.Reference ref = firbase_storage
                            .FirebaseStorage.instance
                            .ref('/blogapp$date');
                        UploadTask uploadTask = ref.putFile(_image!.absolute);
                        await Future.value(uploadTask);
                        var newUrl = await ref.getDownloadURL();
                        final User? user = _auth.currentUser;
                        final BlogService _blogService =
                            BlogService(uid: user!.uid);
                        dynamic response = await _blogService.insertBlog(
                            titleController.text.toString(),
                            descriptionController.text.toString(),
                            newUrl.toString(),
                            autherController.text.toString(),
                            user.email.toString(),
                            linkController.text.toString());
                        toastMessage("BLOG PUBLISHED SUCCESSFULLY!");

                        if (response) {
                          setState(() {
                            showSpinner = false;
                          });
                        }

                        // postRef.child('post list').child(date.toString()).set({
                        //   'pId': date.toString(),
                        //   'pImage': newUrl.toString(),
                        //   'pTime': date.toString(),
                        //   'pTitle': titleController.text.toString(),
                        //   'pDescription': descriptionController.text.toString(),
                        //   'pAuther': autherController.text.toString(),
                        //   'pEmail': user!.email.toString(),
                        //   'uid': user.uid.toString(),
                        // }).then((value) {
                        //   toastMessage('Post Published');
                        //   setState(() {
                        //     showSpinner = false;
                        //   });
                        // }).onError((error, stackTrace) {
                        //   toastMessage(error.toString());
                        //   setState(() {
                        //     showSpinner = false;
                        //   });
                        // });
                      } catch (e) {
                        setState(() {
                          showSpinner = false;
                        });
                        toastMessage(e.toString());
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
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
