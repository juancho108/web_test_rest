import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/productModel.dart';

Future<ProductModel> fetchAlbum() async {
  final response = await http.get(
      'https://us-central1-digital-step-la-plata.cloudfunctions.net/dstepApi/api/product');

  if (response.statusCode == 201) {
    //return ProductModel.fromJson(json.decode(response.body).product[0]);

    List<dynamic> body = jsonDecode(response.body)['product'];
    return ProductModel.fromJson(body.first);

    // List<ProductModel> products = body
    //     .map(
    //       (dynamic item) => ProductModel.fromJson(item),
    //     )
    //     .toList();
    // return products.first;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Product');
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<ProductModel> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<ProductModel>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListTile(
                  title: Text(snapshot.data.name),
                  subtitle: Text(snapshot.data.category),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:posta/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(title: 'Prueba'),
    );
  }
}
*/
