import 'package:cloud_firestore/cloud_firestore.dart';

class BlogService {
  final String uid;
  BlogService({required this.uid});

  //collection Reference
  final CollectionReference blogCollection =
      FirebaseFirestore.instance.collection('blogs');

  Future insertDummy() async {
    return await blogCollection.doc("allBlogs").set({
      'totalBlog': 0,
      'blog': FieldValue.arrayUnion([
        {
          "title": "Welcome to Blog App",
          "description": "This the description of the blog",
          "image":
              "https://cdn.logojoy.com/wp-content/uploads/2018/05/30164225/572.png",
          "Time": DateTime.now(),
          "author": "Amish Domadiya",
          "email": "amish@gmail.com",
          "uId": uid,
        }
      ]),
    });
  }

  Future updateTotalBlogs(int totalBlogs) async {
    return await blogCollection.doc("allBlogs").update({
      'totalBlog': totalBlogs,
    });
  }

  Future insertBlog(
    String title,
    String description,
    String image,
    String email,
    String author,
    String link,
  ) async {
    List newListToBeStored = [];
    newListToBeStored.add({
      "title": title,
      "description": description,
      "image": image,
      "Time": DateTime.now(),
      "author": author,
      "email": email,
      "link": link,
      "uId": uid,
    });
    FirebaseFirestore.instance
        .collection('blogs')
        .doc("allBlogs")
        .get()
        .then((snapshot) async {
      updateTotalBlogs(snapshot['totalBlog'] + 1);
      return await blogCollection.doc("allBlogs").update({
        'blog': FieldValue.arrayUnion(newListToBeStored),
      });
    });
  }

  Future updateBlog(String title, String description, int index) async {
    return await FirebaseFirestore.instance
        .collection('notebook')
        .doc(uid)
        .get()
        .then((snapshot) {
      final retrievedDateTime = snapshot.data()!['notes'][index]['dateTime'];
      final String retrievedTitle = snapshot.data()!['notes'][index]['title'];
      final String retrievedDescription =
          snapshot.data()!['notes'][index]['description'];
      final String retrievedLink = snapshot.data()!['notes'][index]['link'];

      List updatedListToBeStored = [], listToBeDeleted = [];
      listToBeDeleted.add({
        "title": retrievedTitle,
        "description": retrievedDescription,
        "dateTime": retrievedDateTime,
        "link": retrievedLink
      });

      updatedListToBeStored.add({
        "title": title,
        "description": description,
        'dateTime': retrievedDateTime,
      });

      blogCollection.doc(uid).update({
        'notes': FieldValue.arrayUnion(updatedListToBeStored),
        'lastUpdated': DateTime.now(),
      });

      blogCollection.doc(uid).update({
        'notes': FieldValue.arrayRemove(listToBeDeleted),
      });
    });
  }

  Future deleteNotes(String title, String description, int index) async {
    List listToBeDeleted = [];
    return await FirebaseFirestore.instance
        .collection('notebook')
        .doc(uid)
        .get()
        .then((snapshot) {
      final int totalNotes = snapshot.data()!['totalNotes'];
      listToBeDeleted.add({
        "title": title,
        "description": description,
        "dateTime": snapshot.data()!['notes'][index]['dateTime'],
      });
      blogCollection.doc(uid).update({
        'notes': FieldValue.arrayRemove(listToBeDeleted),
        'totalNotes': totalNotes - 1,
        'lastUpdated': DateTime.now(),
      });
    });
  }
}
