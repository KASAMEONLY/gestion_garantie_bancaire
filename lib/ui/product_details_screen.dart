import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const/AppColors.dart';

class ProductDetailsScreen extends StatefulWidget {
 // const ProductDetailsScreen({Key? key}) : super(key: key);

  var _product;
  ProductDetailsScreen(this._product);
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool booli=false;
  var profile,banque,name;
  fetchProfil()async{

    var qn = FirebaseFirestore.instance.collection("users-form-data");
    var docSnapshot = await qn.doc(FirebaseAuth.instance.currentUser!.email).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      profile = data?['profile']; // <-- The value you want to retrieve.
      banque = data?['banquecode'];// <-- The value you want to retrieve.
      name=data?['name'];
      booli=(profile=="client"&&banque.isEmpty);
      print("cartprofile: $profile et banque:$banque et nom:$name");
      print("cart: $booli");
      // Call setState if needed.      setState(() {
      //         name=data?['name'];
      //       });
    }
    return profile;
  }

  Future addToCart()async{
    String? docId;
    var datecresyncro=FieldValue.serverTimestamp();
    String idGenerator() {
      final now = DateTime.now();
      return now.microsecondsSinceEpoch.toString();
    }
    var gener=int.tryParse(idGenerator()) ?? 0;
    final FirebaseAuth _auth=FirebaseAuth.instance;
    var currentUser=_auth.currentUser;
    //CollectionReference _collectionRef=FirebaseFirestore.instance.collection("users-cart-items");
    DocumentReference _collectionRef=FirebaseFirestore.instance.collection("users-cart-items").doc(currentUser!.email).collection("items").doc();
    return _collectionRef.set(
      {
        "name":widget._product["product-name"],
        "price":widget._product["product-price"],
        "images":widget._product["product-image"],
        "description":widget._product["product-description"],
        //"numero":int.tryParse(idGenerator()) ?? 0,
        "numero":gener,
        "caution":0,
        "reference":widget._product["product-reference"],
        "date_discount":widget._product["product-dd"],
        //"date_discount":FieldValue.serverTimestamp(),
        //"date_created":FieldValue.serverTimestamp(),
        "date_created":datecresyncro,
        //"date_granted":DateTime.now(),
        "date_granted":DateTime(2000,1,1,0,0,0),
        "banque":_chosenValue,
        "agent":"",
        "email": FirebaseAuth.instance.currentUser!.email,
        "client":name,
        "raisonsupp":"",
        "etat":"en cours!",
        "date_limited":DateTime(2000,1,1,0,0,0),
      }).then((value) async =>{
    docId = _collectionRef.id,
    await FirebaseFirestore.instance.collection("garantiesbanque")
        .doc(_chosenValue!).collection("items")
        .doc(docId)
        .set({
      "userid":FirebaseAuth.instance.currentUser!.email,
      "garantieid":docId,
      "name":widget._product["product-name"],
      "price":widget._product["product-price"],
      "images":widget._product["product-image"],
      "description":widget._product["product-description"],
      "numero":gener,
      "caution":0,
      "reference":widget._product["product-reference"],
      "date_discount":widget._product["product-dd"],
      "date_created":datecresyncro,
      "date_granted":DateTime(2000,1,1,0,0,0),
      "banque":_chosenValue,
      "agent":"",
      "client":name,
      "etat":"en cours!",
      "raisonsupp":"",
      "date_limited":DateTime(2000,1,1,0,0,0),
    }),
       /* await FirebaseFirestore.instance.collection('${_chosenValue}_user_data').doc(docId).update(
        {
          'id' : docId
        }),
        await FirebaseFirestore.instance.collection("garantiesbanque")
        .doc(_chosenValue!).collection("items")
        .doc(docId)
        .set({"userid":FirebaseAuth.instance.currentUser!.email,
      "garantieid":docId}),*/
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Vous avez ajouté une Garantie avec succès!'))),
    Navigator.of(context).pop(),
      print("Ajouté à garantie!")});

  }
  String? _chosenValue;

  void _showDecline() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // set up the buttons
        Widget cancelButton = TextButton(
          child: Text("Annuler"),
          onPressed:  () { Navigator.of(context).pop();},
        );
        Widget continueButton = TextButton(
          child: Text("Valider"),
          onPressed:  () {addToCart();},
        );
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: new Text("Choisir Banque"),
              content:
              Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                new Text("Faites confiance à :"),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: new DropdownButton<String>(
                      hint: Text('Choisir votre banque'),
                      value: _chosenValue,
                      underline: Container(),
                      items: <String>[
                        'UAB',
                        'BCIAB',
                        'BCEAO',
                        'Coris',
                        'BOA',
                        'EcoBank'
                      ].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(
                            value,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _chosenValue = value as String;
                        });
                      },
                    )),
              ]),
              actions: <Widget>[
                cancelButton,
                continueButton,
                // usually buttons at the bottom of the dialog
               /* new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),*/
              ],
            );
          },
        );
      },
    );
  }

  Future addToFavorite()async{
    final FirebaseAuth _auth=FirebaseAuth.instance;
    var currentUser=_auth.currentUser;
    CollectionReference _collectionRef=FirebaseFirestore.instance.collection("users-favorite-items");
    return _collectionRef.doc(currentUser!.email).collection("items").doc().set(
        {
          "name":widget._product["product-name"],
          "price":widget._product["product-price"],
          "images":widget._product["product-image"],
          "reference":widget._product["product-reference"],
          "date_discount":widget._product["product-dd"],
          "description":widget._product["product-description"],
        }).then((value)=>{print("Ajouté à Favoris!"),
     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Marché public ajouté en favoris avec succès!'))),});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.deep_green,
            child: IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back,color: Colors.white,)),
          ),
        ),
        actions: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users-favorite-items").doc(
              FirebaseAuth.instance.currentUser!.email).collection("items").where("reference",isEqualTo: widget._product['product-reference'])
            .snapshots(),
      builder: (BuildContext context,AsyncSnapshot snapshot){
              if(snapshot.data==null){
                return Text("");
              }
              return Padding(
                padding: const EdgeInsets.only(right:8.0),
                child: CircleAvatar(
                  backgroundColor: AppColors.deep_green,
                  child: IconButton(
                    onPressed: ()=>snapshot.data.docs.length==0?addToFavorite():print("Déjà epinglé!") ,
                    icon: snapshot.data.docs.length==0? Icon(
                      Icons.bookmark_outline,
                      color: Colors.white,):Icon(
                      Icons.bookmark_outlined,
                      color: Colors.white,),
                  ),
                ),
              );
               },
            ),

  ],
          ),
      body: FutureBuilder(
        future: fetchProfil(),
         builder: (context, snapshot) {
    if (!snapshot.hasData) {
    return Center(
    child: CircularProgressIndicator()
    );
    }
    return SafeArea(child: Padding(
          padding: const EdgeInsets.only(left: 12,right: 12,top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(aspectRatio: 3.5,
                child: CarouselSlider(items: widget._product['product-image']
                    .map<Widget>((item) => Padding(
                  padding: const EdgeInsets.only(left:3,right: 3),
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(item),fit: BoxFit.fitWidth)
                    ),
                  ),
                )).toList(), options: CarouselOptions(
                    autoPlay: false,
                    enlargeCenterPage: true,
                    viewportFraction: 0.8,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    onPageChanged: (val, carouselPageChangedReason){
                      setState((){
                        //_dotPosition=val;
                      });
                    }
                )),
              ),
              Text(widget._product['product-name'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
              Text(widget._product['product-description']),
              SizedBox(
                height: 10,
              ),
              Text("FCFA ${widget._product['product-price'].toString()}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.green),),
              Divider(),
              SizedBox(
                width: 1.sw,
                height: 56.h,

                child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("users-cart-items").doc(
                        FirebaseAuth.instance.currentUser!.email).collection("items").where("reference",isEqualTo: widget._product['product-reference'])
                        .snapshots(),
                    builder: (BuildContext context,AsyncSnapshot snapshot){
                      if(snapshot.data==null){
                        return Text("");
                      }
                    return booli?ElevatedButton(
                      onPressed: () =>snapshot.data.docs.length==0?_showDecline():print("Déjà garanteddddlol!"),
                      style: snapshot.data.docs.length==0?ElevatedButton.styleFrom(
                        primary: AppColors.deep_green,
                        elevation: 3,
                      ):ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        elevation: 3,
                      ),
                      child: snapshot.data.docs.length==0?Text(
                        "Payer Garantie!",
                        style: TextStyle(
                            color: Colors.white, fontSize: 18.sp),
                      ):Text(
                        "Traitement Garantie En Cours!",
                        style: TextStyle(
                            color: Colors.white, fontSize: 18.sp),
                      ),
                    ):Text("");
                  }
                ),
              ),
            ],
          ),
        ));}
      ),
    );
  }
}
