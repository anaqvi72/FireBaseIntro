import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:create_social/model/user.dart' as m;
import 'package:create_social/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _fs = FirestoreService();
  var users = [];

  @override
  void initState() {
    super.initState();
    getList();
    getStreamList();
  }

  void getStreamList() {
    _db.collection("users").snapshots().listen((snapshots) {
      for (var element in snapshots.docs) {
        setState(() {
          users.add(element.data()["name"]);
        });
      }
    });
  }

  void getList() {
    _db.collection("users").get().then((result) {
      setState(() {
        for (var element in result.docs) {
          users.add(m.User.fromJson(element.data()));
        }
      });
    });
  }

  void getStreamList2() async {
    var result = await _db.collection("users").get();
    for (var element in result.docs) {
      users.add(element.data()["name"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Basic Home"),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(title: Text(users[index]));
        },
      ),
    );
  }
}
