import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gestion_garantie_bancaire/ui/home_screen.dart';

import '../const/AppColors.dart';
import '../widgets/customButton.dart';
import '../widgets/myTextField.dart';

class UserFormScreen extends StatefulWidget {
   //const UserFormScreen({Key? key}) : super(key: key);
   var _profile;
   UserFormScreen(this._profile);
 
   @override
   State<UserFormScreen> createState() => _UserFormScreenState();
 }
 
 class _UserFormScreenState extends State<UserFormScreen> {
   TextEditingController _nameController = TextEditingController();
   TextEditingController _phoneController = TextEditingController();
   TextEditingController _dobController = TextEditingController();
   TextEditingController _genderController = TextEditingController();
   TextEditingController _ageController = TextEditingController();
   List<String> gender = ["Male", "Female", "Other"];

   Future<void> _selectDateFromPicker(BuildContext context) async {
     final DateTime? picked = await showDatePicker(
       context: context,
       initialDate: DateTime(DateTime.now().year - 20),
       firstDate: DateTime(DateTime.now().year - 30),
       lastDate: DateTime(DateTime.now().year),
     );
     if (picked != null) {
       setState(() {
         _dobController.text = "${picked.day}/ ${picked.month}/ ${picked.year}";
       });
     }
   }

   sendUserDataToDB()async{

     final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;
     var currentUser = _firebaseAuth.currentUser;

     CollectionReference _collectionReference = FirebaseFirestore.instance.collection("users-form-data");
     return _collectionReference.doc(currentUser!.email).set({
       "banquecode":widget._profile?_chosenValue:"",
       "name": _nameController.text,
       "phone": _phoneController.text,
       "date": _dobController.text,
       "gender": _genderController.text,
       "age": _ageController.text,
       "profile":widget._profile?"agentbanque":"client",
     }).then((value) => Navigator.push(context, MaterialPageRoute(builder: (_)=>HomeScreen()))).catchError((error)=>print("Quelcque chose s'est mal passée!"));
   }
   String? _chosenValue;
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       body: SafeArea(
         child: Padding(
           padding: EdgeInsets.all(20.w),
           child: SingleChildScrollView(
             scrollDirection: Axis.vertical,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 SizedBox(
                   height: 20.h,
                 ),
                 Text(
                   "Finir votre inscription.",
                   style:
                   TextStyle(fontSize: 22.sp, color: AppColors.deep_green),
                 ),
                 Text(
                   "Vos informations ne seront pas partagées.",
                   style: TextStyle(
                     fontSize: 14.sp,
                     color: Color(0xFFBBBBBB),
                   ),
                 ),
                 SizedBox(
                   height: 15.h,
                 ),
                 widget._profile? DropdownButton<String>(
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
                 ):Container(),
                 myTextField("votre nom!",TextInputType.text,_nameController),
                 myTextField("votre numero tel!",TextInputType.number,_phoneController),
                 /*TextField(
                   keyboardType: TextInputType.text,
                   controller: _nameController,
                   decoration: InputDecoration(hintText: "votre nom!"),
                 ),*/
                 /*TextField(
                   keyboardType: TextInputType.number,
                   controller: _phoneController,
                   decoration: InputDecoration(hintText: "votre numero tel!"),
                 ),*/
                 TextField(
                   controller: _dobController,
                   readOnly: true,
                   decoration: InputDecoration(
                     hintText: "Date de naissance",
                     suffixIcon: IconButton(
                       onPressed: () => _selectDateFromPicker(context),
                       icon: Icon(Icons.calendar_today_outlined),
                     ),
                   ),
                 ),
                 TextField(
                   controller: _genderController,
                   readOnly: true,
                   decoration: InputDecoration(
                     hintText: "Selectionner Genre",
                     prefixIcon: DropdownButton<String>(
                       hint: Text('Genre'),
                       items: gender.map((String value) {
                         return DropdownMenuItem<String>(
                           value: _genderController.text,
                           child: new Text(value),
                           onTap: () {
                             setState(() {
                               _genderController.text = value;
                             });
                           },
                         );
                       }).toList(),
                       onChanged: (_) {},
                     ),
                   ),
                 ),
                 TextField(
                   keyboardType: TextInputType.number,
                   controller: _ageController,
                   decoration: InputDecoration(hintText: "votre âge!"),
                 ),
                 //myTextField("enter your age",TextInputType.number,_ageController),

                 SizedBox(
                   height: 50.h,
                 ),

                 // elevated button
                 /*SizedBox(
                   width: 1.sw,
                   height: 56.h,
                   child: ElevatedButton(
                     onPressed: () {
                       sendUserDataToDB();
                     },
                     style: ElevatedButton.styleFrom(
                       primary: AppColors.deep_green,
                       elevation: 3,
                     ),
                     child: Text(
                       "Terminer",
                       style: TextStyle(
                           color: Colors.white, fontSize: 18.sp),
                     ),
                   ),
                 ),*/

                 // elevated button
                 customButton("Terminer",()=>sendUserDataToDB()),
               ],
             ),
           ),
         ),
       ),
     );
   }
 }
 