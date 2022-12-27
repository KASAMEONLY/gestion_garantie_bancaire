import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gestion_garantie_bancaire/const/AppColors.dart';
import 'package:gestion_garantie_bancaire/ui/product_details_screen.dart';
import 'package:gestion_garantie_bancaire/ui/searchtest1.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  List<String> _carouselImages=[];
  List _carouselImagesvedette=[];
  List _outputList=[];
  List<String> _carouselImagesPro=[];
  var _dotPosition=0;
  var _firestoreInstance = FirebaseFirestore.instance;
  List _products=[];
 // late List<QueryDocumentSnapshot<Object?>> _iamapro=[];
  //TextEditingController _searchController = TextEditingController();

  fetchCarouselSlider()async{
    //var _firestoreInstance = FirebaseFirestore.instance;
    QuerySnapshot qn = await _firestoreInstance.collection("carousel-slider").get();
    setState((){
      for(int i=0;i<qn.docs.length;i++){
        _carouselImages.add(
          qn.docs[i]["image-path"],
        );
        print(qn.docs[i]["image-path"]);
    }
    });
    return qn.docs;
  }

  fetchCarouselSliderVedette()async{
    //var _firestoreInstance = FirebaseFirestore.instance;
    QuerySnapshot qn = await _firestoreInstance.collection("products").get();
   // print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA $qn");
    //_iamapro=qn.docs; une autre fois
    setState((){
      for(int i=0;i<qn.docs.length;i++){
        _carouselImagesvedette.add(
            {
              "carousel":qn.docs[i]["product-image"][0],
              "product-name":qn.docs[i]["product-name"],
              "envedette":qn.docs[i]["envedette"],
              "product-description":qn.docs[i]["product-description"],
              "product-price":qn.docs[i]["product-price"],
              "product-image":qn.docs[i]["product-image"],
              "product-id":qn.docs[i].id,
              "product-ref":qn.docs[i].reference,
              "product-reference":qn.docs[i]["reference"],
              "product-dd":qn.docs[i]["datedd"],
            }
        );
      }print(_carouselImagesvedette);
      _outputList = _carouselImagesvedette.where((o) => o['envedette'] == true).toList();
      print("=================ssssss===============s==========");
      print(_outputList);
      for(int i=0;i<_outputList.length;i++){
        _carouselImagesPro.add(
          _outputList[i]["carousel"],
        );
      } print("##############################you################");print(_carouselImagesPro);
    });
    return qn.docs;
  }

  fetchProducts()async{

    QuerySnapshot qn = await _firestoreInstance.collection("products").get();

    setState((){
      for(int i=0;i<qn.docs.length;i++){
        //_carouselImagesPro.add(qn.docs[i]["product-image"][0],);
        _products.add(
            {
              "product-name":qn.docs[i]["product-name"],
              "product-description":qn.docs[i]["product-description"],
              "product-dd":qn.docs[i]["datedd"],
              "product-price":qn.docs[i]["product-price"],
              "product-image":qn.docs[i]["product-image"],
              "product-id":qn.docs[i].id,
              "product-ref":qn.docs[i].reference,
              "product-reference":qn.docs[i]["reference"],

            }
        ); print("${qn.docs[i].id} lol ${qn.docs[i].reference} lala ${qn.docs[i].reference.id}");
        //print(qn.docs[i]["image-path"]);
      }
    });
    return qn.docs;
  }
  
  @override
  void initState() {
    fetchCarouselSlider();
    fetchCarouselSliderVedette();
    fetchProducts();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
  //final NumberFormat formatter = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString());
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top:10,left: 20.w,right:20.w),
                child: TextFormField(
                  //controller: _searchController,
                  readOnly: true,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      borderSide: BorderSide(
                        color: Colors.blue
                      )
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        borderSide: BorderSide(
                            color: Colors.grey
                        )
                    ),
                    prefixIcon: Icon(Icons.search),
                    hintText: "Chercher Marchés Publics",
                    hintStyle: TextStyle(fontSize: 15.sp),
                  ),
                  onTap: ()=>Navigator.push(context, CupertinoPageRoute(builder: (_)=>ImbissList(products: _products,))),
                ),
              ),
              SizedBox(height: 10.h,),
              AspectRatio(aspectRatio: 3.5,
              child: CarouselSlider(items: _carouselImagesPro.map((item) => Padding(
                padding: const EdgeInsets.only(left:3,right: 3),
                child: GestureDetector(
                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ProductDetailsScreen(_outputList[_dotPosition]))),
                  child: Container(
                    margin:EdgeInsets.all(2.0),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(item),
                            fit: BoxFit.fitHeight,
                           // alignment: Alignment.topCenter,
                          ),
                        ),
                        child:  Center(
                          child: Text("${_outputList[_dotPosition]["product-name"]}",
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              backgroundColor: Colors.black45,
                              color: Colors.white,
                            ),),
                        ),
                      ),
                    ),
                  ),
                ),
              )).toList(), options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                onPageChanged: (val, carouselPageChangedReason){
                  setState((){
                    _dotPosition=val;
                  });
                }
              )),
              ),
              SizedBox(height: 10.h,),
              DotsIndicator(dotsCount: _carouselImagesPro.length==0?1:_carouselImagesPro.length,
                position: _dotPosition.toDouble(),
                decorator: DotsDecorator(
                  activeColor: AppColors.deep_green,
                  color: AppColors.deep_green.withOpacity(0.5),
                  spacing: EdgeInsets.all(2),
                  activeSize: Size(8,8),
                  size: Size(6,6),
                ),
              ),
              //ElevatedButton(onPressed: ()=>print(_products), child: Text("Afficher Produits"),)
              SizedBox(height: 15.h,),
              Expanded(child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1),
                  itemBuilder: (_,index){
                return GestureDetector(
                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ProductDetailsScreen(_products[index]))),
                  child:/* Card(
                    elevation: 3,
                    child: Column(
                      children: [
                        AspectRatio(aspectRatio: 2,child: Container(color: Colors.redAccent,
                        child:Image.network(_products[index]["product-image"][0]))),
                        Text("${_products[index]["product-name"]}"),
                        Text("${_products[index]["product-price"].toString()}"),
                      ],
                    ),
                  ),*/ Card(
                  clipBehavior: Clip.antiAlias,
                  // TODO: Adjust card heights (103)
                    child: Column(
                      // TODO: Center items on the card (103)
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            _products[index]["product-image"][0],
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  // TODO: Align labels to the bottom and center (103)
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // TODO: Change innermost Column (103)
                                  children: <Widget>[
                                    // TODO: Handle overflowing labels (103)
                                    Text(
                                      _products[index]["product-name"],
                                      style: theme.textTheme.headline6,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                        "FCFA ${_products[index]["product-price"].toString()}",
                                        style: theme.textTheme.subtitle2,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                ),
                );
                  }),
              )

            ],
          ),
        ),
      ),
    );
  }
}
