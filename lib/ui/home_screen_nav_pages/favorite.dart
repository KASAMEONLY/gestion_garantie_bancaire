import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../product_details_screen.dart';


class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List _products=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users-favorite-items").doc(FirebaseAuth.instance.currentUser!.email).collection("items").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.hasError){
            return Center(child: Text("Une erreur s'est produite"),);
          }
          if(snapshot.data?.docs.length==0){
            return Center(child:Text("Pas de favoris pour l'instant!"),);
          }
    for(int i=0;i<snapshot.data!.docs.length;i++){
    //_carouselImagesPro.add(qn.docs[i]["product-image"][0],);
    _products.add(
    {
    "product-name":snapshot.data!.docs[i]["name"],
    "product-description":snapshot.data!.docs[i]["description"],
    "product-dd":snapshot.data!.docs[i]["date_discount"],
    "product-price":snapshot.data!.docs[i]["price"],
    "product-image":snapshot.data!.docs[i]["images"],
    "product-reference":snapshot.data!.docs[i]["reference"],

    });}
          return ListView.builder(
              itemCount:snapshot.data!.docs.length,
              itemBuilder: (_,index){
                DocumentSnapshot _documentSnapshot=snapshot.data!.docs[index];
                return Card(
                  elevation: 5,
                  child: ListTile(
                    leading: Text(_documentSnapshot['name']),
                    title: Text("FCFA ${_documentSnapshot['price']}",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),),
                    trailing: GestureDetector(
                      child: CircleAvatar(
                        child: Icon(Icons.remove_circle),
                      ),
                      onTap: (){
                        FirebaseFirestore.instance.collection("users-favorite-items").doc(FirebaseAuth.instance.currentUser!.email).collection("items")
                            .doc(_documentSnapshot.id).delete();
                      },
                    ),
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ProductDetailsScreen(_products[index]))),
                  ),
                );
              }
          );
        },
      ),
      ),
    );
  }
}
