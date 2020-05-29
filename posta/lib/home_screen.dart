import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:posta/models/productModel.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: getProducts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData) {
            List<ProductModel> posts = snapshot.data;
            return ListView(
              children: posts
                  .map(
                    (ProductModel p) => ListTile(
                      title: Text(p.name),
                      subtitle: Text(p.category),
                    ),
                  )
                  .toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<List<ProductModel>> getProducts() async {
    final response = await http.get(
        'https://us-central1-digital-step-la-plata.cloudfunctions.net/dstepApi/api/product');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)["product"];

      List<ProductModel> products = body
          .map(
            (dynamic item) => ProductModel.fromJson(item),
          )
          .toList();

      return products;
    } else {
      // se a responsta não for OK , lançamos um erro
      throw Exception('Falla al cargar los productos');
    }
  }
}
