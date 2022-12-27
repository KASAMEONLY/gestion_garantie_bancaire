import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
//import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
//import 'package:printing/printing.dart';


import '../const/AppColors.dart';

class GaraDetailsScreen extends StatefulWidget {
  // const GaraDetailsScreen({Key? key}) : super(key: key);

  var _product;
  GaraDetailsScreen(this._product);
  @override
  State<GaraDetailsScreen> createState() => _GaraDetailsScreenState();
}

class _GaraDetailsScreenState extends State<GaraDetailsScreen> {
  final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();

  void _printScreen() {
    Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      final doc = pw.Document();

      final image = await WidgetWraper.fromKey(
        key: _printKey,
        pixelRatio: 2.0,
      );

      doc.addPage(pw.Page(
          pageFormat: format,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Expanded(
                child: pw.Image(image),
              ),
            );
          }));

      return doc.save();
    });
  }
  @override
  Widget build(BuildContext context) {
    String date_created=DateFormat('dd-MMM-yyyy - HH:mm:ss').format(widget._product['date_created'].toDate());
    String date_granted=DateFormat('dd-MMM-yyyy - HH:mm:ss').format(widget._product['date_granted'].toDate());
    String date_limited=DateFormat('dd-MMM-yyyy - HH:mm:ss').format(widget._product['date_limited'].toDate());
    String date_discount=DateFormat('dd-MMM-yyyy - HH:mm:ss').format(widget._product['date_discount'].toDate());
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
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.only(left: 12,right: 12,top: 10),
        child: SingleChildScrollView(
          child: RepaintBoundary(
            key: _printKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*RepaintBoundary(
                  key: _printKey,
                  child:
                  // This is the widget that will be printed.
                  const FlutterLogo(
                    size: 300,
                  ),
                ),*/
                Row(children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orangeAccent,
                      elevation: 3,
                    ),
                    child: Text("PDF",),
                    onPressed: () {
                    },
                  ),
                ),Spacer(),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                      elevation: 3,
                    ),
                    child: Text("PRINT",),
                    onPressed: () {
                      _printScreen();
                    },
                  ),
                ),
              ],
              ),
                Divider(),
                AspectRatio(aspectRatio: 3.5,
                  child: CarouselSlider(items: widget._product['images']
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
                ),Divider(),
                Text("[ ${widget._product['reference']}] ${widget._product['name']}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                Text(widget._product['description']),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text("Montant garantie: "),
                    Text("FCFA ${widget._product['price'].toString()}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blueGrey),),
                  ],
                ),

                Row(
                  children: [
                    Text("Numero garantie: "),
                    Text("${widget._product['numero'].toString()}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.deepPurple),),
                  ],
                ),
                Row(
                  children: [
                    Text("Montant caution: "),
                    Text("FCFA ${widget._product['caution'].toString()}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),),
                  ],
                ),Divider(),
                Row(
                  children: [
                    Text("Date-demande: "),

                    Text(date_created,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.brown),),
                  ],
                ),
                Row(
                  children: [
                    Text("Date-discount: "),
                    Text(date_discount,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.teal),),
                  ],
                ),
                Row(
                  children: [
                    Text("Date-obtention: "),
                    Text(date_granted,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.yellow),),
                  ],
                ),
                Row(
                  children: [
                    Text("Date-limite: "),
                    Text(date_limited,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.pinkAccent),),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text("Client: "),
                    Text("${widget._product['client'].toString()}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green),),
                  ],
                ),
                Row(
                  children: [
                    Text("Email Client: "),
                    Text("${widget._product['email'].toString()}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.amber),),
                  ],
                ),
                Row(
                  children: [
                    Text("Banque: "),
                    Text("${widget._product['banque'].toString()}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),),
                  ],
                ),
                Row(
                  children: [
                    Text("Agent: "),
                    Text("${widget._product['agent'].toString()}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blue),),
                  ],
                ),
                if(widget._product['raisonsupp'].toString().isNotEmpty)Row(
                  children: [
                    Text("Raison suppression: "),
                    Text("${widget._product['raisonsupp'].toString()}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green),),
                  ],
                ),
                Divider(),
                SizedBox(
                  width: 1.sw,
                  height: 56.h,

                  child: Row(children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orangeAccent,
                          elevation: 3,
                        ),
                        child: Text("Etat garantie: ${widget._product['etat'].toString()}",
                          style: TextStyle(
                              color: Colors.white, fontSize: 18.sp),),
                        onPressed: () {
                        },
                      ),
                    ),
                  ],
                  ),
                  ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
