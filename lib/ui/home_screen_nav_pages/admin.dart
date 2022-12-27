import 'package:animated_radial_menu/animated_radial_menu.dart';
import 'package:flutter/material.dart';
import 'package:gestion_garantie_bancaire/ui/home_screen_nav_pages/admin_nav_pages/admin_product.dart';
import 'package:gestion_garantie_bancaire/ui/home_screen_nav_pages/admin_nav_pages/admin_profile.dart';
import 'package:gestion_garantie_bancaire/ui/home_screen_nav_pages/admin_nav_pages/admin_test.dart';
import 'package:gestion_garantie_bancaire/ui/home_screen_nav_pages/admin_nav_pages/stats.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RadialMenu(
            children: [
              RadialButton(
                  icon: Icon(Icons.ac_unit),
                  buttonColor: Colors.teal,
                  onPress: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_)=>AdminTest()))
                      .catchError((error)=>print("Quelcque chose s'est mal passée!"))),
              RadialButton(
                  icon: Icon(Icons.camera_alt),
                  buttonColor: Colors.green,
                  onPress: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_)=>AdminProducts()))
                      .catchError((error)=>print("Quelcque chose s'est mal passée!"))),
              RadialButton(
                  icon: Icon(Icons.map),
                  buttonColor: Colors.orange,
                  onPress: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_)=>BarChartSample1()))
                      .catchError((error)=>print("Quelcque chose s'est mal passée!"))),
              RadialButton(
                  icon: Icon(Icons.watch),
                  buttonColor: Colors.pink,
                  onPress: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_)=>AdminProfile()))
                      .catchError((error)=>print("Quelcque chose s'est mal passée!"))),
              RadialButton(
                  icon: Icon(Icons.access_alarm),
                  buttonColor: Colors.indigo,
                  onPress: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_)=>AdminProfile()))
                      .catchError((error)=>print("Quelcque chose s'est mal passée!"))),
              RadialButton(
                  icon: Icon(Icons.settings),
                  buttonColor: Colors.blue,
                  onPress: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_)=>AdminProfile()))
                      .catchError((error)=>print("Quelcque chose s'est mal passée!"))),
              RadialButton(
                  icon: Icon(Icons.mail_outline),
                  buttonColor: Colors.yellow,
                  onPress: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_)=>AdminProfile()))
                      .catchError((error)=>print("Quelcque chose s'est mal passée!"))),
              RadialButton(
                  icon: Icon(Icons.logout),
                  buttonColor: Colors.red,
                  onPress: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_)=>AdminProfile()))
                      .catchError((error)=>print("Quelcque chose s'est mal passée!"))),
            ],
          ),
        ],
      ),
    );
  }
}
