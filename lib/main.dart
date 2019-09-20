import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
 
const request = 'https://api.hgbrasil.com/finance?format=json-&key=f43b37b9';

void main(){
 runApp(MaterialApp(
   debugShowCheckedModeBanner: false,
   home: MyHome(),
 ));
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("\$ Currency Converter \$", style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
    );
  }
}