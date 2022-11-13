import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:readmore/readmore.dart';

import 'package:screenshot/screenshot.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class adminScreen extends StatefulWidget {
  const adminScreen({Key? key, required this.useremail}) : super(key: key);

  final String useremail;
  @override
  State<adminScreen> createState() => _adminScreenState(useremail);
}

class _adminScreenState extends State<adminScreen> {
  String useremail;

  _adminScreenState(this.useremail);

  TextEditingController startingdate = TextEditingController();
  TextEditingController endingingdate = TextEditingController();
  final dbRef = FirebaseDatabase.instance.reference().child('Posts');
  FirebaseAuth auth = FirebaseAuth.instance;

  ScreenshotController _screenshotController = ScreenshotController();
  TextEditingController searchController = TextEditingController();
  String search = "";
  DateTime? pickedDatestart;
  DateTime? pickedDateend;

  void fetchTheData() async {
    await FirebaseFirestore.instance
        .collection("blogs")
        .doc("allBlogs")
        .get()
        .then((value) => {print("${value["blog"][0]["author"]}")});
  }

  @override
  void initState() {
    startingdate.text = "";
    endingingdate.text = ""; //set the initial value of text field
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
    return Scaffold(
        appBar: AppBar(
          title: Text("DatePicker in Flutter"), //background color of app bar
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: startingdate,
                //editing controller of this TextField
                decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today), //icon of text field
                    labelText: "Enter Date" //label text of field
                    ),
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
                  pickedDatestart = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2100));

                  if (pickedDatestart != null) {
                    print(
                        pickedDatestart); //pickedDate output format => 2021-03-10 00:00:00.000
                    String startformattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDatestart!);
                    print(
                        "mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
                    print(
                        startformattedDate); //formatted date output using intl package =>  2021-03-16
                    setState(() {
                      startingdate.text =
                          startformattedDate; //set output date to TextField value.
                    });
                  } else {}
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: endingingdate,
                //editing controller of this TextField
                decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today), //icon of text field
                    labelText: "Enter Date" //label text of field
                    ),
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
                  pickedDateend = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      // DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2100));

                  if (pickedDateend != null) {
                    print(pickedDateend);
                    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
                    //pickedDate output format => 2021-03-10 00:00:00.000
                    String endformattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDateend!);
                    print(
                        endformattedDate); //formatted date output using intl package =>  2021-03-16
                    setState(() {
                      endingingdate.text =
                          endformattedDate; //set output date to TextField value.
                    });
                  } else {}
                },
              ),
              SizedBox(
                height: 20,
              ),
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
                    final DateTime dateTimee = itemDetail['Time'].toDate();
                    final String link = itemDetail['link'];
                    var formatter = DateFormat('yyyy-MM-dd');

                    String formattedDate = formatter.format(dateTimee);
                    String sharestring = "Title = " +
                        title +
                        "          " +
                        "Description = " +
                        desc;
                    // String formattedDate = formatter.format(dateTime);
                    // SimpleDateFormate
                    // print(formattedDate);
                    // print("");
                    print(
                        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
                    print(dateTimee);
                    print("starting=");
                    print(pickedDatestart);
                    print("ending=");
                    print(pickedDateend);
                    print(
                        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
                    if (searchController.text.isEmpty &&
                        pickedDateend == null &&
                        pickedDatestart == null) {
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
                    } else if (title.toLowerCase().contains(search) &&
                        pickedDateend == null &&
                        pickedDatestart == null) {
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
                    } else if (title.toLowerCase().contains(search) &&
                        pickedDateend == null &&
                        dateTimee.isAfter(pickedDatestart!)) {
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
                    } else if (title.toLowerCase().contains(search) &&
                        dateTimee.isAfter(pickedDatestart!) &&
                        dateTimee.isBefore(pickedDateend!)) {
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
                    } else if (title.toLowerCase().contains(search) &&
                        dateTimee.isAfter(pickedDatestart!) &&
                        pickedDatestart == null) {
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
                    } else if (searchController.text.isEmpty &&
                        dateTimee.isBefore(pickedDateend!) &&
                        pickedDatestart == null) {
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
                          Center(
                              child: SizedBox(
                            // child: CircularProgressIndicator(),
                            height: 50,
                            width: 50,
                          )),
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
        ));
  }
}
