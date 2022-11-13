import 'package:cloud_firestore/cloud_firestore.dart';

class BlogDatabaseService {
  final String uid;
  BlogDatabaseService({required this.uid});

  //collection Reference
  final CollectionReference blogCollection =
      FirebaseFirestore.instance.collection('blogs');

  Future insertDummyData() async {
    return await blogCollection.doc(uid).set({
      'totalBlog': 1,
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

  Future updateTotalNotes(int totalNotes) async {
    return await blogCollection.doc(uid).update({
      'totalNotes': totalNotes,
    });
  }

  Future insertNotes(
      String title, String description, DateTime lastUpdated) async {
    List newListToBeStored = [];
    newListToBeStored.add({
      "title": title,
      "description": description,
      'dateTime': DateTime.now(),
    });
    FirebaseFirestore.instance
        .collection('notebook')
        .doc(uid)
        .get()
        .then((snapshot) {
      updateTotalNotes(snapshot['totalNotes'] + 1);
    });
    return await blogCollection.doc(uid).update({
      'notes': FieldValue.arrayUnion(newListToBeStored),
      'lastUpdated': lastUpdated,
    });
  }

  // * NOTE: While implementing updateNotes I get to know that there is no any method of FieldValue to directly update the List<List> of Firebase so I have First Remove List and then add another one.
  // ? REQUEST: If you found any other good solution that is better then this one let me know or raise a issue. I would love to know that.
  Future updateNotes(String title, String description, int index) async {
    return await FirebaseFirestore.instance
        .collection('notebook')
        .doc(uid)
        .get()
        .then((snapshot) {
      final retrievedDateTime = snapshot.data()!['notes'][index]['dateTime'];
      final String retrievedTitle = snapshot.data()!['notes'][index]['title'];
      final String retrievedDescription =
          snapshot.data()!['notes'][index]['description'];
      List updatedListToBeStored = [], listToBeDeleted = [];
      listToBeDeleted.add({
        "title": retrievedTitle,
        "description": retrievedDescription,
        "dateTime": retrievedDateTime
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
