import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gestion_garantie_bancaire/ui/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  const firebaseConfig = FirebaseOptions(
      apiKey: "AIzaSyA9uZPOWZ4QjisV_T28nOH9gyYNaWEZDEY",
      authDomain: "gestion-garantie-bancaire.firebaseapp.com",
      projectId: "gestion-garantie-bancaire",
      storageBucket: "gestion-garantie-bancaire.appspot.com",
      messagingSenderId: "945511926299",
      appId: "1:945511926299:web:4ed8a14d03da1b44cd06be",
      measurementId: "G-715EZLFPRF"
  );


  if(kIsWeb){

    await Firebase.initializeApp(
      options: firebaseConfig,
    );
  }else{
    await Firebase.initializeApp();
  }
 /* await Firebase.initializeApp(
      name: 'gestion-garantie-bancaire-web',
     // options: DefaultFirebaseOptions.currentPlatform,
      options: const FirebaseOptions(
      apiKey: "AIzaSyA9uZPOWZ4QjisV_T28nOH9gyYNaWEZDEY",
      authDomain: "gestion-garantie-bancaire.firebaseapp.com",
      projectId: "gestion-garantie-bancaire",
      storageBucket: "gestion-garantie-bancaire.appspot.com",
      messagingSenderId: "945511926299",
      appId: "1:945511926299:web:4ed8a14d03da1b44cd06be",
      measurementId: "G-715EZLFPRF"));
  */
  runApp(const MyApp());
}
/*const firebaseConfig = FirebaseOptions(
    apiKey: "AIzaSyA1S7r-kyTOCLWttcf4kC3Qye0s-gl96Ec",
    appId: "1:390108250565:web:9821516ca39ba976358bac",
    messagingSenderId: "390108250565",
    projectId: "doc-appointment-aa751",
  );


  if(kIsWeb){

    await Firebase.initializeApp(
      options: firebaseConfig,
    );
  }else{
    await Firebase.initializeApp();
  }
  another:
  /// in main.dart
import 'package:flutter/foundation.dart' show kIsWeb;
...
if (kIsWeb) {
    await Firebase.initializeApp(
      name: fireStoreInstanceName,
      options: const FirebaseOptions(
          apiKey: "xxxxxxxxxxxx",
          appId: "1:xxxxxx",
          messagingSenderId: "xxxxxxx",
          projectId: "xxxx"),
    );
  } else {
    await Firebase.initializeApp(name: fireStoreInstanceName);
  }

/// to get Firestore instance
FirebaseFirestore? getFirestoreInstance() {
    for (var app in Firebase.apps) {
      if (app.name == fireStoreInstanceName) {
        return FirebaseFirestore.instanceFor(app: app);
      }
    }
    return null;
  }

    /// use of instance
    FirebaseFirestore? instance = getFirestoreInstance();
    if (instance == null) {
      return likes;
    }
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await instance.collection("my_doc").get();
  try {

// you can also assign this app to a FirebaseApp variable
// for example app = await FirebaseApp.initializeApp...

    await Firebase.initializeApp(
      name: 'SecondaryApp',
      options: FirebaseOptions(
        appId: '<appID>',
        apiKey: '<APIKey>',
        messagingSenderId: '<msgSID>',
        projectId: '<projectID>',
        databaseURL: '<dbUrl>/',
      ),
    );
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app') {
// you can choose not to do anything here or either
// In a case where you are assigning the initializer instance to a FirebaseApp variable, // do something like this:
//
//   app = Firebase.app('SecondaryApp');
//
    } else {
      throw e;
    }
  } catch (e) {
    rethrow;
  }
void main() async {
  await Firebase.initializeApp(
      name: "YourAppName",
      options: FirebaseOptions(
          apiKey: '<apiKey>',
          appId: '<appId>',
          messagingSenderId: '<senderId>',
          projectId: '<projectId>'));

  runApp(MyApp());
}*/
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (context , child){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Gestion Garantie Bancaire',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
