import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstbd233/constante/constant.dart';

class MyUser {
  late String uid;
  late String nom;
  late String prenom;
  late String email;
  String? avatar;
  DateTime? birthday;
  late Genre genre;
  String favorite = "";

  MyUser(){
    uid = "";
    nom = "";
    prenom = "";
    email = "";
    genre = Genre.autres;
  }


  MyUser.bdd(DocumentSnapshot snapshot){
    uid = snapshot.id;
    Map<String,dynamic> map = snapshot.data() as Map<String,dynamic>;
    nom = map["NOM"];
    prenom = map["PRENOM"];
    email = map["EMAIL"];
    avatar = map["AVATAR"]??defaultImage;

    Timestamp? timestamp = map["BIRTHDAY"];
    if(timestamp == null){
      birthday = DateTime.now();
    }
    else
      {
        birthday = timestamp.toDate();
      }

  }

  //méthode
  String get fullName {
    return prenom + " " + nom;
  }


}