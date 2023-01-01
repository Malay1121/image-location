import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_location/main.dart';
import 'package:image_location/screens/create_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await generateFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (var doc in getStorage.read('feed').toString() == null
                      ? '["BDdlKDzBMvoO4bStBmIk"]'
                      : getStorage.read('feed'))
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(doc.toString())
                          .get(),
                      builder: ((context, snapshot1) {
                        return Column(
                          children: [
                            Image.network(
                              snapshot1.data == null
                                  ? 'https://www.citypng.com/public/uploads/preview/loading-load-icon-transparent-png-11639609114lctjenyas8.png'
                                  : 'https://firebasestorage.googleapis.com/v0/b/image-location-1e578.appspot.com/o/${snapshot1.data!.id + snapshot1.data!["creator"]}.png?alt=media',
                            ),
                            FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(snapshot1.data == null
                                        ? 'mfRqKsYswphcNGidMcAzrqRAJFq2'
                                        : snapshot1.data!['creator'])
                                    .get(),
                                builder: (context, snapshot2) {
                                  return Text(snapshot2.data == null
                                      ? 'wait'
                                      : snapshot2.data!['username']);
                                }),
                          ],
                        );
                      }),
                    ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreatePost()));
                    },
                    child: Text('Create Post'),
                  ),
                ],
              ),
            ),
            // FutureBuilder(
            //     future: FirebaseFirestore.instances
            //         .collection('users')
            //         .doc(getStorage.read('id'))
            //         .collection('feed')
            //         .doc('feed')
            //         .get(),
            //     builder: (BuildContext context, snapshot) {
            //       if (snapshot.hasError) {
            //         return Text("Something went wrong");
            //       }

            //       if (snapshot.hasData && !snapshot.data!.exists) {
            //         return Text(getStorage.read('id'));
            //       }
            //       if (snapshot.connectionState == ConnectionState.done) {
            //         Map<String, dynamic> data =
            //             snapshot.data!.data() as Map<String, dynamic>;
            //         return Text(data.toString());
            //       }
            //       return Text("loading");
            //     }),
          ],
        ),
      ),
    );
  }

  Future<void> generateFeed() async {
    getStorage.write('feed', []);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(getStorage.read('id'))
        .get()
        .then((value) {
      var keys = value.data()!['preferences'];
      for (var key in keys.keys.toList()) {
        FirebaseFirestore.instance
            .collection('posts')
            .where('categories', arrayContains: key.toString())
            .get()
            .then((value) {
          print(value.docs);

          List feed = [];
          value.docs.forEach((element) {
            setState(() {
              feed.add(element.id);
            });
          });
          getStorage.write('feed', feed);
        });
      }
    });
  }
}
