import 'dart:io';
import 'dart:math';

import 'package:blogapp/components/drawer.dart';
import 'package:blogapp/screens/aboutussecrren.dart';
import 'package:blogapp/screens/add_post.dart';
import 'package:blogapp/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firbase_storage;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:share/share.dart';
import 'package:blogapp/screens/myblogScreen.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/round_buttom.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.useremail}) : super(key: key);

  final String useremail;

  @override
  _HomeScreenState createState() => _HomeScreenState(useremail);
}

class _HomeScreenState extends State<HomeScreen> {
  String useremail;
  _HomeScreenState(this.useremail);
  final dbRef = FirebaseDatabase.instance.reference().child('Posts');
  FirebaseAuth auth = FirebaseAuth.instance;

  ScreenshotController _screenshotController = ScreenshotController();
  TextEditingController searchController = TextEditingController();
  String search = "";
  int count = 0;
  bool _islinkedButtonClicked = false;

  void fetchTheData() async {
    await FirebaseFirestore.instance
        .collection("blogs")
        .doc("allBlogs")
        .get()
        .then((value) => {print("${value["blog"][0]["author"]}")});
  }

  @override
  void initState() {
    super.initState();

    print("EMaila here: ${widget.useremail}");
    fetchTheData();
    searchController.addListener(() {
      print(searchController.text.toString());
      setState(() {
        search = searchController.text.toString();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: searchController,
                keyboardType: TextInputType.emailAddress,
                onSaved: (newString) {
                  print("NEW: $newString");
                  setState(() {
                    search = newString!;
                  });
                },
                decoration: InputDecoration(
                    hintText: 'Search with Blog Title',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder()),
                onChanged: (String value) {
                  search = value;
                },
              ),
              // Expanded(
              //   child: FirebaseAnimatedList(
              //     query: dbRef.child('post list'),
              //     itemBuilder: (BuildContext context, DataSnapshot snapshot,
              //         Animation<double> animation, int index) {
              //       String tempTitle = (snapshot.value as dynamic)['pTitle'];
              //       if (searchController.text.isEmpty) {
              //         return Padding(
              //           padding: const EdgeInsets.all(10.0),
              //           child: Container(
              //             decoration: BoxDecoration(
              //                 color: Colors.grey.shade100,
              //                 borderRadius: BorderRadius.circular(10)),
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 ClipRRect(
              //                   borderRadius: BorderRadius.circular(10),
              //                   child: Image.network(
              //                     (snapshot.value as dynamic)['pImage'],
              //                     fit: BoxFit.cover,
              //                     width: MediaQuery.of(context).size.width * 1,
              //                     height:
              //                         MediaQuery.of(context).size.height * .55,
              //                   ),
              //                 ),
              //                 const SizedBox(height: 10),
              //                 Padding(
              //                   padding:
              //                       const EdgeInsets.symmetric(horizontal: 10),
              //                   child: Text(
              //                     (snapshot.value as dynamic)['pAuther'],
              //                     style: const TextStyle(
              //                       fontSize: 20,
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //                   ),
              //                 ),
              //                 Padding(
              //                   padding:
              //                       const EdgeInsets.symmetric(horizontal: 10),
              //                   child: Text(
              //                     (snapshot.value as dynamic)['pTitle'],
              //                     style: const TextStyle(
              //                       fontSize: 15,
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //                   ),
              //                 ),
              //                 Padding(
              //                   padding:
              //                       const EdgeInsets.symmetric(horizontal: 10),
              //                   child: Text(
              //                     (snapshot.value as dynamic)['pDescription'],
              //                     style: const TextStyle(
              //                       fontSize: 18,
              //                       fontWeight: FontWeight.normal,
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         );
              //       } else if (tempTitle
              //           .toLowerCase()
              //           .contains(searchController.text.toString())) {
              //         return Padding(
              //           padding: const EdgeInsets.all(10.0),
              //           child: Container(
              //             decoration: BoxDecoration(
              //                 color: Colors.grey.shade100,
              //                 borderRadius: BorderRadius.circular(10)),
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 ClipRRect(
              //                   borderRadius: BorderRadius.circular(10),
              //                   child: Image.network(
              //                     (snapshot.value as dynamic)['pImage'],
              //                     fit: BoxFit.cover,
              //                     width: MediaQuery.of(context).size.width * 1,
              //                     height:
              //                         MediaQuery.of(context).size.height * .55,
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   height: 10,
              //                 ),
              //                 Padding(
              //                   padding:
              //                       const EdgeInsets.symmetric(horizontal: 10),
              //                   child: Text(
              //                     (snapshot.value as dynamic)['pAuther'],
              //                     style: TextStyle(
              //                         fontSize: 20,
              //                         fontWeight: FontWeight.bold),
              //                   ),
              //                 ),
              //                 Padding(
              //                   padding:
              //                       const EdgeInsets.symmetric(horizontal: 10),
              //                   child: Text(
              //                     (snapshot.value as dynamic)['pTitle'],
              //                     style: TextStyle(
              //                         fontSize: 15,
              //                         fontWeight: FontWeight.bold),
              //                   ),
              //                 ),
              //                 Padding(
              //                   padding:
              //                       const EdgeInsets.symmetric(horizontal: 10),
              //                   child: Text(
              //                     (snapshot.value as dynamic)['pDescription'],
              //                     style: TextStyle(
              //                         fontSize: 18,
              //                         fontWeight: FontWeight.normal),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         );
              //       } else {
              //         return Container();
              //       }
              //       return SizedBox();
              //     },
              //   ),
              // ),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("blogs")
                    .doc("allBlogs")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.data == null) {
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          CircularProgressIndicator(),
                          Text(
                            "Fetching Data...",
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    );
                  }

                  final DocumentSnapshot document =
                      snapshot.data as DocumentSnapshot;

                  final Map<String, dynamic> documentData =
                      document.data() as Map<String, dynamic>;

                  List checkingForEmptyList = documentData["blog"];
                  if (documentData["blog"] == null ||
                      checkingForEmptyList.isEmpty) {
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text(
                            "No Blogs...",
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    );
                  }

                  final List<Map<String, dynamic>> itemDetailList =
                      (documentData["blog"] as List)
                          .map((itemDetail) =>
                              itemDetail as Map<String, dynamic>)
                          .toList();
                  var itemDetailsListReversed =
                      itemDetailList.reversed.toList();

                  _buildListTileHere(int index) {
                    final Map<String, dynamic> itemDetail =
                        itemDetailsListReversed[index];
                    final String title = itemDetail['title'];
                    final String image = itemDetail['image'];
                    final String desc = itemDetail['description'];
                    final String author = itemDetail['email'];
                    final String emailc = itemDetail['author'];
                    final DateTime dateTime = itemDetail['Time'].toDate();

                    var formatter = DateFormat('yyyy-MM-dd');

                    String formattedDate = formatter.format(dateTime);
                    String sharestring = "Title = " +
                        title +
                        "          " +
                        "Description = " +
                        desc;
                    final String link = itemDetail['link'];
                    if (useremail == emailc) {
                      print(count);
                      count = count + 1;
                    }
                    if (searchController.text.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.orangeAccent,
                                        child: Icon(
                                          Icons.person_rounded,
                                          color: Colors.black,
                                          size: 35,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            author,
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          Text(
                                            formattedDate,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 10,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Share.share(sharestring);
                                      },
                                      icon: Icon(Icons.share_outlined)),
                                ],
                              ),
                              AspectRatio(
                                aspectRatio: 14 / 10,
                                child: Image.network(image),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: _islinkedButtonClicked
                                        ? const Icon(Icons.thumb_up)
                                        : const Icon(
                                            Icons.thumb_up_alt_outlined),
                                    onPressed: () {
                                      setState(() {
                                        _islinkedButtonClicked =
                                            !_islinkedButtonClicked;
                                      });
                                    },
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        final url = link;
                                        if (await canLaunch(link)) {
                                          await launch(link);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      },
                                      icon: Icon(Icons.link)),
                                ],
                              ),
                              ReadMoreText(
                                desc,
                                trimLines: 4,
                                textAlign: TextAlign.justify,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: "ShoW More",
                                trimExpandedText: "Show Less",
                                lessStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[700],
                                ),
                                moreStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[700],
                                ),
                                style: TextStyle(fontSize: 14, height: 2),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (title.toLowerCase().contains(search)) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.orangeAccent,
                                        child: Icon(
                                          Icons.person_rounded,
                                          color: Colors.black,
                                          size: 35,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            author,
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          Text(
                                            formattedDate,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 10,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Share.share(sharestring);
                                      },
                                      icon: Icon(Icons.share_outlined)),
                                ],
                              ),
                              AspectRatio(
                                aspectRatio: 14 / 10,
                                child: Image.network(image),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: _islinkedButtonClicked
                                        ? const Icon(Icons.thumb_up)
                                        : const Icon(
                                            Icons.thumb_up_alt_outlined),
                                    onPressed: () {
                                      setState(() {
                                        _islinkedButtonClicked =
                                            !_islinkedButtonClicked;
                                      });
                                    },
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        final url = link;
                                        if (await canLaunch(link)) {
                                          await launch(link);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      },
                                      icon: Icon(Icons.link)),
                                ],
                              ),
                              ReadMoreText(
                                desc,
                                trimLines: 4,
                                textAlign: TextAlign.justify,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: "ShoW More",
                                trimExpandedText: "Show Less",
                                lessStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[700],
                                ),
                                moreStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[700],
                                ),
                                style: TextStyle(fontSize: 14, height: 2),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          // CircularProgressIndicator(),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: itemDetailsListReversed.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildListTileHere(index);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
