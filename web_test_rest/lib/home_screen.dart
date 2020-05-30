import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/product_model.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _showProducts(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              height: 3,
              color: Colors.blue,
              //indent: 25,
              //endIndent: 25,
            ),
          ),
          _showFormAddProduct(),
        ],
      ),
    );
  }

  Widget _showFormAddProduct() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Name",
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2.0,
                ),
              ),
            ),
            keyboardType: TextInputType.text,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: categoryController,
            decoration: InputDecoration(
              labelText: "Category",
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2.0,
                ),
              ),
            ),
            keyboardType: TextInputType.text,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            color: Colors.blueAccent,
            textColor: Colors.white,
            child: Text('Enviar', style: TextStyle(fontSize: 20)),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  FutureBuilder<List<ProductModel>> _showProducts() {
    return FutureBuilder(
      future: getProducts(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          List<ProductModel> list = snapshot.data;

          return Center(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.card_giftcard),
                  title: Text(list[index].name),
                  subtitle: Text(list[index].category),
                );
              },
            ),
          );
        }
      },
    );
  }

  Future<List<ProductModel>> getProducts() async {
    final url =
        "https://us-central1-digital-step-la-plata.cloudfunctions.net/dstepApi/api/product";
    final response = await http.get(url);

    if (response.statusCode == 201 || response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)['product'];

      List<ProductModel> productList =
          body.map((prod) => ProductModel.fromJson(prod)).toList();

      return productList;
    } else {
      throw "No se pudieron traer los productos";
    }
  }

  Future<List<ProductModel>> addProduct() async {
    final url =
        "https://us-central1-digital-step-la-plata.cloudfunctions.net/dstepApi/api/product";
    final response = await http.post(url);

    if (response.statusCode == 201 || response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)['product'];

      List<ProductModel> productList =
          body.map((prod) => ProductModel.fromJson(prod)).toList();

      print(productList);
      return productList;
    } else {
      throw "No se pudieron traer los productos";
    }
  }
}
