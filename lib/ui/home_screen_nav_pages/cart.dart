import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:gestion_garantie_bancaire/ui/gara_details_screen.dart';
import 'package:intl/intl.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List _products=[];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _cautionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _agentController = TextEditingController();
  final TextEditingController  _banqueController = TextEditingController();
  final TextEditingController _clientController = TextEditingController();
  TextEditingController _dategrantedController = TextEditingController();
  TextEditingController _datelimiteController = TextEditingController();
  String _dropDownValue="en cours!"; //bool isSwitched = false;
  //  List<String> _locations = ['Please choose a location', 'A', 'B', 'C', 'D']; // Option 1
//  String _selectedLocation = 'Please choose a location'; // Option 1
 // List<String> _locations = ['en cours!', 'accordée!', 'réfusée!']; // Option 2String _selectedLocation="en cours!"; // Option 2
  bool booli=false; //bool chien=false;
  var profile,banque,name;
   fetchProfil()async{

    var qn = FirebaseFirestore.instance.collection("users-form-data");
    var docSnapshot = await qn.doc(FirebaseAuth.instance.currentUser!.email).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      profile = data?['profile'];
      banque = data?['banquecode'];// <-- The value you want to retrieve.
      name=data?['name'];
      booli=(profile=="agentbanque"&&banque.isNotEmpty);
      print("cartprofile: $profile et banque:$banque");
      print("cart: $booli");
      //booli=booli;
    }

      // Call setState if needed.
     // setState((){ });

    return docSnapshot;
  }
 /* String a="";String b=""; bool _banker=false;
  fetchCarouselSlider()async{
    DocumentSnapshot qn = await FirebaseFirestore.instance.collection("users-form-data").doc(FirebaseAuth.instance.currentUser!.email).get();
    setState((){

       a= qn.get("profile");
       b= qn.get('banquecode');
       _banker=(a=='agentbanque'&&b.isNotEmpty);
       print('reveanchebool: $_banker');
        print(qn);print(qn.get('banquecode'));

    });
    return qn.data();
  }*/
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot,int? index]) async {
    if (documentSnapshot != null) {
      _nameController.text = "["+documentSnapshot['reference']+"] "+documentSnapshot['name'];
      _imageController.text = documentSnapshot['images'][0];
      _priceController.text = documentSnapshot['price'].toString();
      _cautionController.text = documentSnapshot['caution'].toString();
      _dategrantedController.text = DateFormat('dd-MMM-yyyy - HH:mm:ss').format(documentSnapshot['date_granted'].toDate());
      _datelimiteController.text = DateFormat('dd-MMM-yyyy - HH:mm:ss').format(documentSnapshot['date_limited'].toDate());
      _dropDownValue= documentSnapshot['etat'].toString();
      _clientController.text=documentSnapshot['client'].toString();
      _banqueController.text=documentSnapshot['userid'].toString();
      _agentController.text=name;
      //isSwitched =documentSnapshot['endategranted'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Container(
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter stateSetter) {
                  return Padding(
                    padding: EdgeInsets.only(
                        top: 20,
                        left: 20,
                        right: 20,
                        // prevent the soft keyboard from covering text fields
                        bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //dropdown failed cause trans bool to string
                              Container(
                                width: double.infinity,
                                child: ElevatedButton(onPressed:  () =>"",
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.lightGreenAccent,
                                      elevation: 3,
                                    ),
                                    child: Text("MODIFICATION", style: TextStyle(color: Colors.white, fontSize: 18.sp),)),
                              ),

                          SizedBox(height: 10,),
                          Container(
                            height: 40.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(_imageController.text),
                                fit: BoxFit.fitWidth,
                              ),
                              shape: BoxShape.rectangle,
                            ),
                          ),
                          TextField(
                            enabled: false,
                            controller: _agentController,
                            decoration: const InputDecoration(labelText: 'Agent Banque'),
                          ),
                          TextField(
                            enabled: false,
                            controller: _clientController,
                            decoration: const InputDecoration(labelText: 'Client'),
                          ),
                          TextField(
                            enabled: false,
                            controller: _banqueController,
                            decoration: const InputDecoration(labelText: 'Email Client'),
                          ),
                   DropdownButtonFormField(
                  hint: _dropDownValue == null
                  ? Text('Choisir etat')
                        : Text(
                  _dropDownValue,
                  style: TextStyle(color: Colors.blue),
                  ),
                       decoration: InputDecoration(
                         filled: true,
                         labelText: 'Etat-garantie',
                       ),
                  isExpanded: true,
                  iconSize: 30.0,
                  style: TextStyle(color: Colors.blue),
                  items: ['en cours!', 'accordée!', 'refusée!'].map(
                  (val) {
                  return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val),
                  );
                  },
                  ).toList(),
                  value: _dropDownValue,
                  onChanged: (val) {
                  setState(
                  () {
                  _dropDownValue = val as String;
                  },
                  );
                  },
                  ),
                          Row(children: [
                            Expanded(
                              child: TextField(
                                enabled: false,
                                controller: _dategrantedController,
                                decoration: const InputDecoration(labelText: 'Garantie accordée le:'),
                              ),
                            ),
                        ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  elevation: 3,
                                ),
                                child: Text("Choisir",),
                                onPressed: () {
                                   DatePicker.showDatePicker(context,
                                      dateFormat: 'dd MMMM yyyy HH:mm:ss',
                                      locale: DateTimePickerLocale.fr,
                                      initialDateTime: DateTime.now(),
                                      minDateTime: DateTime(2020),
                                      maxDateTime: DateTime(3000),
                                      onMonthChangeStartWithFirstDate: true,
                                      onConfirm: (dateTime, List<int> index) {
                                        DateTime selectdate = dateTime;
                                        final selIOS = DateFormat('dd-MMM-yyyy - HH:mm:ss').format(selectdate);
                                        _dategrantedController.text=selIOS;
                                        print(selIOS);print("datewa: $_dategrantedController");
                                      },

                                    );
                                },
                              ),
                      ],
                  ),

                          Row(children: [
                            Expanded(
                              child: TextField(
                                enabled: false,
                                controller: _datelimiteController,
                                decoration: const InputDecoration(labelText: 'Date limite garantie:'),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                elevation: 3,
                              ),
                              child: Text("Choisir",),
                              onPressed: () {
                               // DateTime tempDate = new DateFormat("dd-MMM-yyyy - HH:mm:ss").parse(_datelimiteController.text);
                               /* Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return DateTimePickerWidget*/
                                DatePicker.showDatePicker(
                                  context,
                                    dateFormat: 'dd MMMM yyyy HH:mm:ss',
                                    locale: DateTimePickerLocale.fr,
                                    //initDateTime: tempDate,
                                    initialDateTime: DateTime.now(),
                                    minDateTime: DateTime(2020),
                                    maxDateTime: DateTime(3000),
                                    onMonthChangeStartWithFirstDate: true,
                                    onConfirm: (dateTime, List<int> index) {
                                      DateTime selectdate = dateTime;
                                      final selIOS = DateFormat('dd-MMM-yyyy - HH:mm:ss').format(selectdate);
                                      _datelimiteController.text=selIOS;
                                      print(selIOS);
                                    },

                                  );
                               // }));
                              },
                            ),
                          ],
                          ),
                          TextField( enabled: false,
                            keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                            controller: _priceController,
                            decoration: const InputDecoration(
                              labelText: 'Prix',
                            ),
                          ),
                          TextField(
                            keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                            controller: _cautionController,
                            decoration: const InputDecoration(
                              labelText: 'Caution',
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            child: Text("Update"),
                            onPressed: () async {
                              //DateTime tempDate = new DateFormat("dd-MMM-yyyy - HH:mm:ss").parse(_datelimiteController.text);
                              final String? etat =_dropDownValue;
                              final String? agent =_agentController.text;
                              final DateTime? dategranted = new DateFormat("dd-MMM-yyyy - HH:mm:ss").parse(_dategrantedController.text);
                              final DateTime? datelimited = new DateFormat("dd-MMM-yyyy - HH:mm:ss").parse(_datelimiteController.text);
                              final double? caution =
                              double.tryParse(_cautionController
                                  .text);
                              if (name != null && caution != null) {

                                  // Update the product
                                await FirebaseFirestore.instance.collection("garantiesbanque")
                                    .doc(banque).collection("items")
                                    .doc(documentSnapshot!.id)
                                    .update({"caution":caution,"etat":etat,"agent":agent,"date_granted":dategranted,
                                  "date_limited":datelimited});
                                  //mettre aussi a jour pour le client
                                await FirebaseFirestore.instance.collection("users-cart-items")
                                    .doc(_banqueController.text).collection("items")
                                    .doc(documentSnapshot.id)
                                    .update({"caution":caution,"etat":etat,"agent":agent,"date_granted":dategranted,
                                  "date_limited":datelimited});
                                //var data = documentSnapshot.data() as Map;if(index!=null) {
                                //                                   _products[index]['caution']=data['caution'];
                                //                                   _products[index]['etat']=data['etat'];
                                //                                   _products[index]['agent']=data['agent'];
                                //                                   _products[index]['date_granted']=data['date_granted'];
                                //                                   _products[index]['date_limited']=data['date_limited'];
                                //                                 }
                                //give default value : int a = product.id ?? 1
                                // force unwrap : int a = prododuct.id!
                                // make optional variable : int? a = product.id
                                if(index!=null) {
                                  _products[index]['caution']=caution;
                                  _products[index]['etat']=etat;
                                  _products[index]['agent']=agent;
                                  _products[index]['date_granted']=Timestamp.fromDate(dategranted!);
                                  _products[index]['date_limited']=Timestamp.fromDate(datelimited!);//print("lupdate:${_products[index]}");
                                }
                                  // Show a snackbar
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text('Garantie modifiée avec succès!')));

                                // Hide the bottom sheet
                                Navigator.of(context).pop();/*setState(() {
                                  fetchProfil();
                                });*/
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  );
                }
            ),
          );
        });
  }
  // Deleteing a product by id
  Future<void> _deleteProduct([DocumentSnapshot? documentSnapshot]) async {
    if(!booli) {
      String chien=documentSnapshot!['raisonsupp'].toString();
      if(chien.isNotEmpty) {
        await FirebaseFirestore.instance.collection("users-cart-items")
    .doc(FirebaseAuth.instance.currentUser!.email).collection("items")
        .doc(documentSnapshot.id).delete();
      }else{
      await FirebaseFirestore.instance.collection("garantiesbanque")
        .doc(documentSnapshot['banque'].toString()).collection("items")
        .doc(documentSnapshot.id).update({"raisonsupp":_chosenValue,"etat":"supprimée par le client"});
      await FirebaseFirestore.instance.collection("users-cart-items")
          .doc(FirebaseAuth.instance.currentUser!.email).collection("items")
          .doc(documentSnapshot.id).delete();}
    }
    if(booli) {
      String chien=documentSnapshot!['raisonsupp'].toString();
      if(chien.isEmpty) {
        await FirebaseFirestore.instance.collection("users-cart-items")
          .doc(documentSnapshot['userid'].toString()).collection("items")
          .doc(documentSnapshot.id).update({"raisonsupp":'supprimée par la banque',"etat":"supprimée par la banque!"});
      }
      await FirebaseFirestore.instance.collection("garantiesbanque")
        .doc(banque).collection("items")
        .doc(documentSnapshot.id).delete();
    }
    Navigator.of(context).pop();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Garantie supprimée avec succès!')));
  }
  String? _chosenValue;
  void _showDecline([DocumentSnapshot? documentSnapshot]) {
    String chien=documentSnapshot!['raisonsupp'].toString();
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
          onPressed:  () {_deleteProduct(documentSnapshot);},
        );
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: !booli&&!chien.isNotEmpty?new Text("Raison suppression"):Text("suppression garantie"),
              content:
              !booli&&!chien.isNotEmpty?Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                new Text("Vous supprimez parceque:"),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: new DropdownButton<String>(
                      hint: Text('Choisir cause'),
                      value: _chosenValue,
                      underline: Container(),
                      items: <String>[
                        'Vous vous êtes trompés',
                        'Pas satisfait du service',
                        'Délai long',
                        'Autre',
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
              ]):Text("Confirmez-vous?"),
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
  @override
  Widget build(BuildContext context) {
   /* print("widgetprofile: $profile et banque:$banque et boool:$booli");
    print("banquepro: $b profilepro: $a boolpro: $_banker");*/
    return Scaffold(
      body: FutureBuilder(
        future: fetchProfil(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(
            child: CircularProgressIndicator()
        );
      }
      return
      SafeArea(child: StreamBuilder(
        stream: booli ? FirebaseFirestore.instance.collection("garantiesbanque")
            .doc(banque!).collection("items")
            .snapshots()
            : FirebaseFirestore.instance.collection("users-cart-items").doc(
            FirebaseAuth.instance.currentUser!.email)
            .collection("items")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(),);
          }
          if (snapshot.hasError) {
            return Center(child: Text("Une erreur s'est produite"),);
          }
          if (snapshot.data?.docs.length == 0) {
            return Center(child: Text("Pas de garanties pour l'instant!"),);
          }
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            //_carouselImagesPro.add(qn.docs[i]["product-image"][0],);
            _products.add(
                {
                  "name": snapshot.data!.docs[i]["name"],
                  "price": snapshot.data!.docs[i]["price"],
                  "images": snapshot.data!.docs[i]["images"],
                  "description": snapshot.data!.docs[i]["description"],
                  "numero": snapshot.data!.docs[i]["numero"],
                  "caution": snapshot.data!.docs[i]["caution"],
                  "reference": snapshot.data!.docs[i]["reference"],
                  "date_discount": snapshot.data!.docs[i]["date_discount"],
                  "date_created": snapshot.data!.docs[i]["date_created"],
                  "date_granted": snapshot.data!.docs[i]["date_granted"],
                  "banque": snapshot.data!.docs[i]["banque"],
                  "agent": snapshot.data!.docs[i]["agent"],
                  //'garantieid':snapshot.data!.docs[i]["garantieid"],
                  if(booli)"email":snapshot.data!.docs[i]["userid"],
                  if(!booli)"email":snapshot.data!.docs[i]["email"],
                  "client": snapshot.data!.docs[i]["client"],
                  "raisonsupp": snapshot.data!.docs[i]["raisonsupp"],
                  "etat": snapshot.data!.docs[i]["etat"],
                  "date_limited": snapshot.data!.docs[i]["date_limited"],
                });
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                DocumentSnapshot _documentSnapshot = snapshot.data!.docs[index];
               print(_products[index]);print("LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL");//print(snapshot.data!.docs[index]);
                //List chiena=_products;chiena[index]=snapshot.data!.docs[index];
                //var data = _documentSnapshot.data() as Map;
               // print(data);
               // _products[index]['name']=data['name'];Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
               /* Timestamp myTimeStamp = Timestamp.fromDate(DateTime.now());
                print(myTimeStamp); Timestamp myTimeStamput=Timestamp(myTimeStamp.seconds, myTimeStamp.nanoseconds);
                print(myTimeStamput);*/
                return Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text(_documentSnapshot['name']),
                    subtitle: Text("FCFA ${_documentSnapshot['price']}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),),
                    leading: Text(_documentSnapshot['etat'], style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),),
                    trailing: GestureDetector(
                      child: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            // Press this button to edit a single product
                            booli?CircleAvatar(
                              child: IconButton(
                                  icon: const Icon(Icons.mode_edit_rounded),
                                  onPressed: () =>
                                      _createOrUpdate(_documentSnapshot,index)),
                            ):Text(""),
                            SizedBox(width: 10),
                            // This icon button is used to delete a single product
                            CircleAvatar(
                              child: IconButton(
                                  icon: const Icon(Icons.remove_circle),
                                  onPressed: () =>
                                      _showDecline(_documentSnapshot)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => GaraDetailsScreen(_products[index]))),
                    /*GestureDetector(
                        child: Row(
                          children: [
                            CircleAvatar(
                              child: Icon(Icons.remove_circle),
                            ),
                            CircleAvatar(
                              child: Icon(Icons.mode_edit_rounded),
                            ),
                          ],
                        ),
                        onTap: (){
                          FirebaseFirestore.instance.collection("users-cart-items").doc(FirebaseAuth.instance.currentUser!.email).collection("items")
                              .doc(_documentSnapshot.id).delete();
                        },

                      ),*/
                  ),
                );
              }
          );
        },
      ),)
      ;
    }),
    );
  }
}
