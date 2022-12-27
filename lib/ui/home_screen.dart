import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestion_garantie_bancaire/const/AppColors.dart';
import 'package:gestion_garantie_bancaire/ui/home_screen_nav_pages/admin.dart';
import 'package:gestion_garantie_bancaire/ui/home_screen_nav_pages/cart.dart';
import 'package:gestion_garantie_bancaire/ui/home_screen_nav_pages/favorite.dart';
import 'package:gestion_garantie_bancaire/ui/home_screen_nav_pages/home.dart';
import 'package:gestion_garantie_bancaire/ui/home_screen_nav_pages/profile.dart';

class HomeScreen extends StatefulWidget {
   const HomeScreen({Key? key}) : super(key: key);
 
   @override
   State<HomeScreen> createState() => _HomeScreenState();
 }
 
 class _HomeScreenState extends State<HomeScreen> {
  final _pages = [Home(),Favorite(),Cart(),Profile(),Admin()];
  int _currentIndex =0;
  bool booli=false;
  var profile;
  fetchProfil()async{

    var qn = FirebaseFirestore.instance.collection("users-form-data");
    var docSnapshot = await qn.doc(FirebaseAuth.instance.currentUser!.email).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      profile = data?['profile']; // <-- The value you want to retrieve.
      booli=(profile=="admin");
      // Call setState if needed.
    }
    return profile;
  }
  _aboutAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("OK"),
      onPressed:  () { Navigator.of(context).pop();},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(

      content: Text("Gestion Garantie Bancaire!\n version: 0.1\n Par KASA inc!"),

      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  @override
  void initState() {
    fetchProfil();
    super.initState();
  }
   @override
   Widget build(BuildContext context) {
     return Scaffold(
      /* appBar: AppBar(
         backgroundColor: Colors.transparent,
         elevation: 0,
         title: const Text(
           "Gestion Garantie Bancaire",
           style: TextStyle(color: Colors.black),
         ),
         centerTitle: true,
         automaticallyImplyLeading: false,
       ),*/
       appBar: AppBar(
         leading: IconButton(
           tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
           icon: const Icon(Icons.menu),
           onPressed: () {},
         ),automaticallyImplyLeading: false,
         title: Text(
           "Gestion Garantie Bancaire",
         ),
         actions: [
           IconButton(
             tooltip: "Favoris",
             icon: const Icon(
               Icons.favorite,
             ),
             onPressed: () {},
           ),
           IconButton(
             tooltip: "Cherche",
             icon: const Icon(
               Icons.search,
             ),
             onPressed: () {},
           ),
           PopupMenuButton(onSelected: (result) {
       if (result == 0) {
         _aboutAlertDialog(context);
       }
     },
               itemBuilder: (context) {return[
               PopupMenuItem(
               child: Text("A propos!"),
       value: 0,
     ),
             /*itemBuilder: (context) {
                [
                 PopupMenuItem(
                   child: Text(
                     "About!",
                   ),
                   onTap: _aboutAlertDialog(context),
                 ),*/
                /* PopupMenuItem(
                   child: Text(
                     "option1",
                   ),
                 ),
                 PopupMenuItem(
                   child: Text(
                     " option2",
                   ),
                 ),*/
               ];
             },
           )
         ],
       ),
       bottomNavigationBar: BottomNavigationBar(
         elevation: 5,
         backgroundColor: Colors.white,
         selectedItemColor: Colors.blueAccent,
         unselectedItemColor: Colors.grey,
         currentIndex: _currentIndex,
         selectedLabelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
         items: [
           BottomNavigationBarItem(icon: Icon(Icons.home),label: "Acceuil",),
           BottomNavigationBarItem(icon: Icon(Icons.bookmark_outlined),label: "Favoris",),
           BottomNavigationBarItem(icon: Icon(Icons.business_center_rounded),label: "Garanties",),
           BottomNavigationBarItem(icon: Icon(Icons.person),label: "Compte",),
           if(booli)BottomNavigationBarItem(icon: Icon(Icons.settings),label: "Administration",),
         ],
         onTap: (index){
           setState((){
             _currentIndex=index;
           });
         },
       ),
       body: _pages[_currentIndex],
     );
   }
 }
 