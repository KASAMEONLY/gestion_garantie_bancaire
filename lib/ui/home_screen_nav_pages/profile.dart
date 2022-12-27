

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';


import '../login_screen.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  TextEditingController ?_nameController;
  TextEditingController ?_ageController;
  TextEditingController ?_phoneController;
  TextEditingController ?_genderController;
  TextEditingController ?_dateController;
  TextEditingController ?_banqueController;
  TextEditingController ?_profileController;
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  TextEditingController _email = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  bool _passwordVisible =true;
  String? _link='';File? _image;


  @override
  void initState() {
    _passwordVisible = true;
    if(FirebaseAuth.instance.currentUser!.photoURL!=null)_link='${FirebaseAuth.instance.currentUser!.photoURL}';
  }
  setDataToTextField(data){
    var profile="";
    var banque="";bool booli=false;
    profile=data?['profile'];
    banque=data?['banquecode']; booli=(banque.isNotEmpty);print("bank$banque");print(booli);
    //_profileController!.text=profile;
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap:  () async {
                  String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    if(kIsWeb){
      PickedFile? pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
      );
    Reference _reference = FirebaseStorage.instance
        .ref('userphotos')
        .child('${FirebaseAuth.instance.currentUser!.email}binary')
        .child("$fileName.jpg");
    await _reference
        .putData(
    await pickedFile!.readAsBytes(),
    SettableMetadata(contentType: 'image/jpeg'),
    )
        .whenComplete(() async {
    await _reference.getDownloadURL().then((value) {
      setState(() {
      _link = value;
      FirebaseAuth.instance.currentUser!.updatePhotoURL(_link);
    });
    _link = value;print(value);print(_link);
    });
    });}else{
//write a code for android or ios
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(pickedFile!=null) {
        _image = File(pickedFile.path);
      }

      final pictureRef = FirebaseStorage.instance
          .ref("userphotos")
          .child("${FirebaseAuth.instance.currentUser!.email}")
          .child("$fileName.jpg");

      await pictureRef.putFile(_image!).whenComplete(() => null);

      final String link = await pictureRef.getDownloadURL();
      print(link);
      print('Uploaded');

      setState(() {
        _link = link;
        FirebaseAuth.instance.currentUser!.updatePhotoURL(_link);
      });
    }

    },
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.grey.shade200,
                  child: CircleAvatar(
                    radius: 70,
                    child: ClipOval(child: _link!.isEmpty?Icon(
                        Icons.account_circle
                    ):Image.network(_link!),),
                  ),
                ),
              ),
              Positioned(
                bottom: 1,
                right: 1,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(Icons.add_a_photo, color: Colors.black),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          50,
                        ),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(2, 4),
                          color: Colors.black.withOpacity(
                            0.3,
                          ),
                          blurRadius: 3,
                        ),
                      ]),
                ),
              ),
            ],
          ),
          Divider(),
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email, size: 24),
            ),
            keyboardType: TextInputType.emailAddress,
            controller: _email= TextEditingController(text: FirebaseAuth.instance.currentUser!.email),
          ),
          Form(
            key: _form,
            child: Column(
              children:  <Widget>[
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _pass,
                  obscureText: _passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe!',
                    hintText: 'Entrez mot de passe!',
                    prefixIcon: Icon(Icons.lock_clock_outlined, size: 24),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    ),),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'mot de passe requis!';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _confirmPass,
                  obscureText: _passwordVisible,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_clock_rounded, size: 24),
                    labelText: 'Mot de passe Confirmation!',
                    hintText: 'Confirmez mot de passe!',
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    ),),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'mot de passe requis!';
                    }
                    if (value!=_pass.text) {
                      return 'mots de passe ne correspondent pas!';
                    }
                    return null;
                  },
                ),

    ]
            ),
          ),

          SizedBox(
            height: 25.h,
          ),
          Row(
            children: [
              ElevatedButton(onPressed: ()=>{_email.text.isNotEmpty?_upemailshowAlertDialog(context):
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email requis!")))}, child: Text("Modifier email")),
              Spacer(),
              ElevatedButton(onPressed: ()=>{_form.currentState!.validate()?_uppassshowAlertDialog(context):
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Verifier mots de passe!")))}, child: Text("Modifier mot-de-passe")),
            ],
          ),
          Divider(),

          if(booli)TextFormField(
            enabled: false,
            controller: _banqueController= TextEditingController(text: banque),
          ),
          TextFormField(
            enabled: false,
            controller: _profileController= TextEditingController(text: profile),
          ),
          TextFormField(
            controller: _ageController= TextEditingController(text: data['age']),
          ),
          TextFormField(
            controller: _dateController= TextEditingController(text: data['date']),
          ),
          TextFormField(
            controller: _genderController= TextEditingController(text: data['gender']),
          ),
          TextFormField(
            controller: _nameController = TextEditingController(text: data['name']),
          ),
          TextFormField(
            controller: _phoneController= TextEditingController(text: data['phone']),
          ),
          SizedBox(
            height: 50.h,
          ),
          ElevatedButton(onPressed: ()=>_updatashowAlertDialog(context), child: Text("Modifier Infos Profil")),
          Divider(),
          Row(
            children: [
              ElevatedButton(onPressed: ()=>_logoutshowAlertDialog(context), child: Text("Se Deconnecter!")),
              Spacer(),
              ElevatedButton(onPressed: ()=>_deleteshowAlertDialog(context), child: Text("Supprimer Compte"))
            ],
          ),
        ],
      ),
    );
  }

  _logoutshowAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Annuler"),
      onPressed:  () { Navigator.of(context).pop();},
    );
    Widget continueButton = TextButton(
      child: Text("Valider"),
      onPressed:  () {_logout();},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(

      content: Text("Confirmez-vous?"),

      actions: [
        cancelButton,
        continueButton,
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
  _deleteshowAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Annuler"),
      onPressed:  () { Navigator.of(context).pop();},
    );
    Widget continueButton = TextButton(
      child: Text("Valider"),
      onPressed:  () {_delete();},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(

      content: Text("Confirmez-vous?"),

      actions: [
        cancelButton,
        continueButton,
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
  _upemailshowAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Annuler"),
      onPressed:  () { Navigator.of(context).pop();},
    );
    Widget continueButton = TextButton(
      child: Text("Valider"),
      onPressed:  () {_updatemail();},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(

      content: Text("Confirmez-vous?"),

      actions: [
        cancelButton,
        continueButton,
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
  _uppassshowAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Annuler"),
      onPressed:  () { Navigator.of(context).pop();},
    );
    Widget continueButton = TextButton(
      child: Text("Valider"),
      onPressed:  () {_updatepass();},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(

      content: Text("Confirmez-vous?"),

      actions: [
        cancelButton,
        continueButton,
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
  _updatashowAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Annuler"),
      onPressed:  () { Navigator.of(context).pop();},
    );
    Widget continueButton = TextButton(
      child: Text("Valider"),
      onPressed:  () {updateData();},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(

      content: Text("Confirmez-vous?"),

      actions: [
        cancelButton,
        continueButton,
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
  _logout() async {
  await FirebaseAuth.instance.signOut().then((value) => print("Deconnexion reussite!"));
  Navigator.of(context).pop();
  Navigator
      .of(context)
      .pushReplacement(
      MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen()
      )
  );
  }
  _delete() async {
    await FirebaseAuth.instance.currentUser!.delete().then((value) => print("Suppression compte reussite!"));;
    Navigator.of(context).pop();
    Navigator
        .of(context)
        .pushReplacement(
        CupertinoPageRoute(
            builder: (BuildContext context) => LoginScreen()
        )
    );
  }
  _updatemail() async {

    await FirebaseFirestore.instance.collection("users-form-data").doc(FirebaseAuth.instance.currentUser!.email).delete()
        .then((value) => print("old email data suppression reussite!"));

    await FirebaseFirestore.instance.collection("users-form-data").doc(_email.text).set(
        {
          "name":_nameController!.text,
          "age":_ageController!.text,
          "date":_dateController!.text,
          "gender":_genderController!.text,
          "phone":_phoneController!.text,
          "banquecode":_banqueController!.text,
          "profile":_profileController!.text,
        }).then((value) => print("affect old email data to new one reussite!"));
    Navigator.of(context).pop();
    await FirebaseAuth.instance.currentUser!.updateEmail(_email.text).then((value) => print("email changé!"));

    Navigator
        .of(context)
        .pushReplacement(
        CupertinoPageRoute(
            builder: (BuildContext context) => LoginScreen()
        )
    );
  }
  _updatepass() async {
    await FirebaseAuth.instance.currentUser!.updatePassword(_pass.text).then((value) => print("password changé!"));
    Navigator.of(context).pop();
    Navigator.of(context)
        .pushReplacement(
        CupertinoPageRoute(
            builder: (BuildContext context) => LoginScreen()
        )
    );
  }
  updateData(){
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update(
        {
          "name":_nameController!.text,
          "age":_ageController!.text,
          "date":_dateController!.text,
          "gender":_genderController!.text,
          "phone":_phoneController!.text,
        }).then((value) => print("Modification reussite!"));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users-form-data")
              .doc(FirebaseAuth.instance.currentUser!.email).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            var data = snapshot.data;
            if(!snapshot.hasData || !snapshot.data.exists){
              return Center(child: const CircularProgressIndicator(),);
            }
            if(data==null){
              return Center(child: CircularProgressIndicator(),);
            }

            return setDataToTextField(data);
          },
        ),
      )),
    );
  }

}
