import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminProducts extends StatefulWidget {
  const AdminProducts({Key? key}) : super(key: key);

  @override
  State<AdminProducts> createState() => _AdminProductsState();
}

class _AdminProductsState extends State<AdminProducts> {
  // text fields' controllers

  //final TextEditingController _boolController = TextEditingController();
  bool isSwitched = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final CollectionReference _productss =
  FirebaseFirestore.instance.collection('products');

  // This function is triggered when the floatting button or one of the edit buttons is pressed
  // Adding a product if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing product
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nameController.text = documentSnapshot['product-name'];
      _descriptionController.text = documentSnapshot['product-description'];
      _imageController.text = documentSnapshot['product-image'][0];
      _priceController.text = documentSnapshot['product-price'].toString();
      isSwitched =documentSnapshot['envedette'];
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                 //dropdown failed cause trans bool to string

                  Switch(
                  value: isSwitched,
                    onChanged: (value) {
                      stateSetter(() {
                        isSwitched = value;
                        print(isSwitched);
                      });
                    },
                  ),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(labelText: 'Description'),
                      ),
                      TextField(
                        controller: _imageController,
                        decoration: const InputDecoration(labelText: 'Imagepath'),
                      ),
                      TextField(
                        keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                        controller: _priceController,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        child: Text(action == 'create' ? 'Create' : 'Update'),
                        onPressed: () async {
                          final String? name = _nameController.text;
                          final String? description = _descriptionController.text;
                          final String? image = _imageController.text;
                          final double? price =
                          double.tryParse(_priceController.text);
                          if (name != null && price != null) {
                            if (action == 'create') {
                              // Persist a new product to Firestore
                              await _productss.add({"product-name": name, "product-price": price,"product-description":description,
                                'envedette': true, 'product-image': [image,image],});
                            }

                            if (action == 'update') {
                              // Update the product
                              await _productss
                                  .doc(documentSnapshot!.id)
                                  .update({"product-name": name, "product-price": price,"product-description":description,
                                'envedette': isSwitched, 'product-image': [image,image],});
                            }

                            // Clear the text fields
                            _nameController.text = '';
                            _descriptionController.text = '';
                            _imageController.text = '';
                            _priceController.text = '';
                            isSwitched=false;

                            // Hide the bottom sheet
                            Navigator.of(context).pop();
                          }
                        },
                      )
                    ],
                  ),
                );
              }
            ),
          );
        });
  }

  // Deleteing a product by id
  Future<void> _deleteProduct(String productId) async {
    await _productss.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Products'),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _productss.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['product-name']),
                    subtitle: Text(documentSnapshot['product-price'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Press this button to edit a single product
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          // This icon button is used to delete a single product
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteProduct(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // Add new product
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
