import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ui/product_details_screen.dart';

Widget fetchData(String collectionName){
  return StreamBuilder(
    stream: FirebaseFirestore.instance.collection(collectionName).doc(FirebaseAuth.instance.currentUser!.email).collection("items").snapshots(),
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
      return ListView.builder(
          itemCount: snapshot.data!.docs.length,
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
                    FirebaseFirestore.instance.collection(collectionName).doc(FirebaseAuth.instance.currentUser!.email).collection("items")
                        .doc(_documentSnapshot.id).delete();
                  },
                ),
              ),
            );
          }
      );
    },
  );
}