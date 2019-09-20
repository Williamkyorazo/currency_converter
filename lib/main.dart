import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
 
const request = 'https://api.hgbrasil.com/finance?format=json-&key=f43b37b9';

void main(){
 runApp(MaterialApp(
   theme: ThemeData(
     inputDecorationTheme: InputDecorationTheme(
       enabledBorder: OutlineInputBorder(
         borderSide: BorderSide(color: Colors.red)
       )
     )
   ),
   debugShowCheckedModeBanner: false,
   home: MyHome(),
 ));
}

Future<Map> getData() async{
 http.Response response = await http.get(request);
 return json.decode(response.body);
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  double dolar;
  double euro;

  //controladores dos campos de texto
  final realCotroller = TextEditingController();
  final doalrCotroller = TextEditingController();
  final euroCotroller = TextEditingController();
  
  //funcções de calculos e converção
  void _realChanged(String text){
    double real = double.parse(realCotroller.text);
    doalrCotroller.text = (real / dolar).toStringAsFixed(2);
    euroCotroller.text = (real / euro).toStringAsFixed(2);
  }
  void _dolarChanged(String text){
    double dolar = double.parse(doalrCotroller.text);
    realCotroller.text = (dolar * this.dolar).toStringAsFixed(2);
    euroCotroller.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }
  void _euroChanged(String text){
    double euro = double.parse(euroCotroller.text);
    realCotroller.text = (euro * this.euro).toStringAsFixed(2);
    doalrCotroller.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }
  //fim das funcções 

  //resetar campos
  void _resetFields(){
    realCotroller.text = "";
    doalrCotroller.text = "";
    euroCotroller.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("\$ Currency Converter \$", style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh),
          onPressed: (){_resetFields();},)
        ],
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
            return Center(
              child: Text("Carregando os dados", style: TextStyle(
                color: Colors.red, fontSize: 25.0
              ),
              ),
            );
            default:
            if (snapshot.hasError) {
              return Center(
              child: Text("Erro ao carregar os dados", style: TextStyle(
                color: Colors.red, fontSize: 25.0
              ),
              ),
            );
            }else {
              dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
              euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
              return 
                SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on, size: 170.0, color: Colors.red,),
                        buildTextField("Reais", "R\$", realCotroller, _realChanged),
                        Divider(),
                        buildTextField("Dolares", "US\$", doalrCotroller,_dolarChanged),
                        Divider(),
                        buildTextField("Euros", "€", euroCotroller,_euroChanged)
                      ],
                    ),
                  ),
                );
              
            }
          }
      },
      ),
    );
  }
}
//função Widget que retorna um TextField chamado posteriormente dentro da Column 
Widget buildTextField(String label, String hintText, TextEditingController c, Function f ){
  return TextFormField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.red, fontSize: 20.0),
        border: OutlineInputBorder(),
        hintText: hintText,
      ),
      style: TextStyle(fontSize: 25.0, color: Colors.red),
      keyboardType: TextInputType.number,
      onChanged: f,
    );
}