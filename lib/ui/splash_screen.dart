 import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gestion_garantie_bancaire/const/AppColors.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
   const SplashScreen({Key? key}) : super(key: key);
 
   @override
   State<SplashScreen> createState() => _SplashScreenState();
 }
 
 class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3),()=>Navigator.push(context, CupertinoPageRoute(builder: (_)=>LoginScreen())));
    super.initState();
  }
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: AppColors.deep_green,
       body: SafeArea(
         child:  Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [

               Text("Gestion-Garantie-Bancaire",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.sp),),
               SizedBox(height: 20.h,),
               CircularProgressIndicator(color: Colors.white,),
             ],
           ),
         ),
       ),
     );
   }
 }
 