import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gestion_garantie_bancaire/const/AppColors.dart';
import 'package:gestion_garantie_bancaire/ui/login_screen.dart';
import 'package:gestion_garantie_bancaire/ui/user_form_screen.dart';


class RegistrationScreen extends StatefulWidget {
   const RegistrationScreen({Key? key}) : super(key: key);
 
   @override
   State<RegistrationScreen> createState() => _RegistrationScreenState();
 }
 
 class _RegistrationScreenState extends State<RegistrationScreen> {
   TextEditingController _emailController = TextEditingController();
   TextEditingController _passwordController = TextEditingController();
   bool _obscureText = true;
   bool _checkedValue=false;

   signUp() async{
     try {
       final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
         email: _emailController.text,
         password: _passwordController.text,
       );
       var authCredential = credential.user;
       print(authCredential!.uid);
       if(authCredential.uid.isNotEmpty){
         Navigator.push(context, CupertinoPageRoute(builder: (_)=>UserFormScreen(_checkedValue)));
       }
       else{
         Fluttertoast.showToast(msg: "Quelque chose s'est mal passé!");
       }
     } on FirebaseAuthException catch (e) {
       if (e.code == 'weak-password') {
         Fluttertoast.showToast(msg: "Le mot de passe soumis est trop faible.");
         //print('Le mot de passe soumis est trop faible.');
       } else if (e.code == 'email-already-in-use') {
         Fluttertoast.showToast(msg: "Cet email est déjà associé à un compte.");
         //print('Cet email est déjà associé à un compte.');
       }
     } catch (e) {
       print(e);
     }

   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: AppColors.deep_green,
       body: SafeArea(
         child:  Column(
           children: [
             SizedBox(
               height: 150.h,
               width: ScreenUtil().screenWidth,
               child: Padding(
                 padding: EdgeInsets.only(left: 20.w),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     IconButton(
                       onPressed: null,
                       icon: Icon(
                         Icons.light,
                         color: Colors.transparent,
                       ),
                     ),
                     Text(
                       "S'inscrire",
                       style: TextStyle(fontSize: 22.sp, color: Colors.white),
                     ),
                   ],
                 ),
               ),
             ),
             Expanded(
               child: Container(
                 width: ScreenUtil().screenWidth,
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.only(
                     topLeft: Radius.circular(28.r),
                     topRight: Radius.circular(28.r),
                   ),
                 ),
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
                           "Bienvenue!",
                           style: TextStyle(
                               fontSize: 22.sp, color: AppColors.deep_green),
                         ),
                         Text(
                           "Heureux de vous revoir!",
                           style: TextStyle(
                             fontSize: 14.sp,
                             color: Color(0xFFBBBBBB),
                           ),
                         ),
                         SizedBox(
                           height: 15.h,
                         ),
                         Row(
                           children: [
                             Container(
                               height: 48.h,
                               width: 41.w,
                               decoration: BoxDecoration(
                                   color: AppColors.deep_green,
                                   borderRadius: BorderRadius.circular(12.r)),
                               child: Center(
                                 child: Icon(
                                   Icons.email_outlined,
                                   color: Colors.white,
                                   size: 20.w,
                                 ),
                               ),
                             ),
                             SizedBox(
                               width: 10.w,
                             ),
                             Expanded(
                               child: TextField(
                                 controller: _emailController,
                                 decoration: InputDecoration(
                                   hintText: "votre mail",
                                   hintStyle: TextStyle(
                                     fontSize: 14.sp,
                                     color: Color(0xFF414041),
                                   ),
                                   labelText: 'EMAIL',
                                   labelStyle: TextStyle(
                                     fontSize: 15.sp,
                                     color: AppColors.deep_green,
                                   ),
                                 ),
                               ),
                             ),
                           ],
                         ),
                         SizedBox(
                           height: 10.h,
                         ),
                         Row(
                           children: [
                             Container(
                               height: 48.h,
                               width: 41.w,
                               decoration: BoxDecoration(
                                   color: AppColors.deep_green,
                                   borderRadius: BorderRadius.circular(12.r)),
                               child: Center(
                                 child: Icon(
                                   Icons.lock_outline,
                                   color: Colors.white,
                                   size: 20.w,
                                 ),
                               ),
                             ),
                             SizedBox(
                               width: 10.w,
                             ),
                             Expanded(
                               child: TextField(
                                 controller: _passwordController,
                                 obscureText: _obscureText,
                                 decoration: InputDecoration(
                                   hintText: "Mot de passe de 6 caractères au moins",
                                   hintStyle: TextStyle(
                                     fontSize: 14.sp,
                                     color: Color(0xFF414041),
                                   ),
                                   labelText: 'Mot de passe',
                                   labelStyle: TextStyle(
                                     fontSize: 15.sp,
                                     color: AppColors.deep_green,
                                   ),
                                   suffixIcon: _obscureText == true
                                       ? IconButton(
                                       onPressed: () {
                                         setState(() {
                                           _obscureText = false;
                                         });
                                       },
                                       icon: Icon(
                                         Icons.remove_red_eye,
                                         size: 20.w,
                                       ))
                                       : IconButton(
                                       onPressed: () {
                                         setState(() {
                                           _obscureText = true;
                                         });
                                       },
                                       icon: Icon(
                                         Icons.visibility_off,
                                         size: 20.w,
                                       )),
                                 ),
                               ),
                             ),
                           ],
                         ),
                         SizedBox(
                           height: 10.h,
                         ),
                         CheckboxListTile(
                           title: Text("Agent de Banque?"),
                           value: _checkedValue,
                           onChanged: (newValue) {
                             setState(() {
                               _checkedValue = newValue!;print(_checkedValue);
                             });
                           },
                           controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                         ),
                         SizedBox(
                           height: 50.h,
                         ),
                         // elevated button
                         SizedBox(
                           width: 1.sw,
                           height: 56.h,
                           child: ElevatedButton(
                             onPressed: () {
                               signUp();
                             },
                             style: ElevatedButton.styleFrom(
                               primary: AppColors.deep_green,
                               elevation: 3,
                             ),
                             child: Text(
                               "Poursuivre",
                               style: TextStyle(
                                   color: Colors.white, fontSize: 18.sp),
                             ),
                           ),
                         ),
                         SizedBox(
                           height: 20.h,
                         ),
                         Wrap(
                           children: [
                             Text(
                               "Vous avez dejà un compte?",
                               style: TextStyle(
                                 fontSize: 13.sp,
                                 fontWeight: FontWeight.w600,
                                 color: Color(0xFFBBBBBB),
                               ),
                             ),
                             GestureDetector(
                               child: Text(
                                 " Se Connecter ",
                                 style: TextStyle(
                                   fontSize: 13.sp,
                                   fontWeight: FontWeight.w600,
                                   color: AppColors.deep_green,
                                 ),
                               ),
                               onTap: () {
                                 Navigator.push(
                                     context,
                                     CupertinoPageRoute(
                                         builder: (context) => LoginScreen()));
                               },
                             ),
                            /* GestureDetector(
                               child: Text(
                                 " User Data Form ",
                                 style: TextStyle(
                                   fontSize: 13.sp,
                                   fontWeight: FontWeight.w600,
                                   color: AppColors.deep_green,
                                 ),
                               ),
                               onTap: () {
                                 Navigator.push(
                                     context,
                                     CupertinoPageRoute(
                                         builder: (context) => UserFormScreen(_checkedValue)));
                               },
                             )*/
                           ],
                         )
                       ],
                     ),
                   ),
                 ),
               ),
             ),
           ],
         ),
       ),
     );
   }
 }
 