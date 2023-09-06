import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constante/constant.dart';
import '../controller/firebase_helper.dart';

class MyFavoritepage extends StatefulWidget {
  const MyFavoritepage({super.key});

  @override
  State<MyFavoritepage> createState() => _MyFavoritepageState();
}

void deleteFavorite(String uid)
{
  FirebaseHelper().cloud_users.doc(uid).update({
    "Favoris":FieldValue.arrayRemove([moi.uid])
  });
}

class _MyFavoritepageState extends State<MyFavoritepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoris'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseHelper().cloud_users.where("Favoris", arrayContains: moi.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data!.docs[index];
              return Card(
                elevation:5,
                color: Colors.white60,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(defaultImage),
                  ),
                  title: Text(ds["PRENOM"]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: (){
                        deleteFavorite(ds.id);
                      }, icon: Icon(Icons.favorite,color: Colors.pink,)),
                    ],
                  ),


                  subtitle: Text(ds["EMAIL"]),
              )
              );
            },
          );
        },
      ),
    );
  }
}
