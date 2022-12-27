import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_garantie_bancaire/ui/product_details_screen.dart';

import '../const/AppColors.dart';

class ImbissList extends StatefulWidget {
  //ImbissList({Key? key}):super.key, required this.products});
  ImbissList ({Key? key, required this.products}) : super(key: key);
  final List products;

  @override
  State<ImbissList> createState() => _ImbissListState();
}

class _ImbissListState extends State<ImbissList> {
  // The search key to filter the imbisses.
  String key = '';
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
     List imbisses = widget.products;
     print('champion${imbisses}');

    // Filter the imbisses using the key.
    imbisses = imbisses.where((imbiss) {
      return imbiss["product-name"].toLowerCase().contains(key.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: new Text('Que Recherchez vous?'),
        elevation: 0.0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.deep_green,
            child: IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back,color: Colors.white,)),
          ),
        ),
      ),
        body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      labelText: "Rechercher",
                      hintText: "Chercher",
                      prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.clear(); setState(() => key = '');},
                        icon: Icon(Icons.clear),),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    // Update the key when the value changes.
                    setState(() => key = value);
                  },
                ),/*trailing: IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                controller.clear(); setState(() => key = '');},),*/
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: imbisses.length,
              itemBuilder: (context, index) {
                return Container(
                    margin:EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: InkWell(
                        onTap: () =>Navigator.push(context, MaterialPageRoute(builder: (_)=>ProductDetailsScreen(imbisses[index]))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,  // add this
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                              child: Image.network(
                                  imbisses[index]['product-image'][0],
                                  // width: 300,
                                  height: 150,
                                  fit:BoxFit.fill

                              ),
                            ),
                            ListTile(
                              title: Text(imbisses[index]["product-name"]),
                              subtitle: Text("FCFA ${imbisses[index]["product-price"].toString()}"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
              },
            ),
          ),
        ],
      ),
    );
  }
}