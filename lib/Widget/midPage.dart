import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app/Model/product_model.dart';
import 'package:http/http.dart' as http;

class MidPage extends StatefulWidget {
  const MidPage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _MidPageState createState() => _MidPageState();
}

class _MidPageState extends State<MidPage> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    );
  }

  Future<List<Products>> fetchProducts() async {
    final response =
        await http.get((Uri.parse('https://dummyjson.com/products')));

    if (response.statusCode == 200) {
      var parsedListJson = json.decode(response.body);
      parsedListJson = parsedListJson['products'];

      List<Products> itemsList = List<Products>.from(parsedListJson
          .map<Products>((dynamic user) => Products.fromJson(user)));
      // ProdList =
      // print(itemsList);
      return itemsList;
    } else {
      throw Exception();
    }
  }
}