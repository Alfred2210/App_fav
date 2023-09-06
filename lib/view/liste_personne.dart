

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstbd233/controller/firebase_helper.dart';
import 'package:flutter/material.dart';

import '../constante/constant.dart';
import '../model/my_user.dart';

class ListPersonne extends StatefulWidget {
  const ListPersonne({super.key});

  @override
  State<ListPersonne> createState() => _ListPersonneState();
}

void delete(String uid){
  FirebaseHelper().cloud_users.doc(uid).delete();
}

void addFavorite(String uid){
  FirebaseHelper().cloud_users.doc(uid).update({
    "Favoris":FieldValue.arrayUnion([moi.uid])
  });
}


void showUserDetails(BuildContext context, MyUser user) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(user.fullName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.avatar!),
            ),
            Text("Mail : " + user.email),
            Text("Nom : " + user.nom!),
            Text("Prénom : " + user.prenom!),
            Text("Favoris : " + user.favorite.toString()),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Fermer")
          ),
        ],
      );
    },
  );
}





class _ListPersonneState extends State<ListPersonne> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseHelper().cloud_users.snapshots(),
        builder: (context,snap){
          if(snap.data == null){
            return Center(child: Text("Aucun utilisateur"),);
          }else {
            List documents = snap.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
                itemBuilder: (context,index){
                MyUser users = MyUser.bdd(documents[index]);
                if(users.uid!=moi.uid)
                  {
                    return Card(
                      elevation: 5,
                      color: Colors.white60,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(users.avatar!),
                        ),
                        title: Text(users.fullName),
                        subtitle: Text(users.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(onPressed: (){
                              addFavorite(users.uid!);

                            }, icon: Icon(Icons.favorite,color: Colors.pink,)),
                            IconButton(onPressed: (){
                              delete(users.uid!);
                            }, icon: Icon(Icons.delete,color: Colors.red,)),
                          ],
                        ),
                        onTap: (){
                          showUserDetails(context, users);
                        },

                      ),


                    );
                  }
                }
            );



          }

        }


    );
  }



}
