import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:appvalet/models/crono.dart';
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

/// La clase principal de la aplicación Flutter
void main() {
  runApp(const MyApp());
}

/// Esta es la clase `MyApp`, que extiende de 'StatelessWidget' y representa la aplicación Flutter
class MyApp extends StatelessWidget {
  
  
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text("valet parking")
        ),
      body: const Center(
        child:const HomePage(),


        
      ),
      )
    
    );

  }

/*Future getUsuarios() async{
 final res= await http.get(Uri.parse(result));
 final  objetos = jsonDecode(res.body);
 final lista = List.from(objetos);
}*/
}

 String result = '';

/// Esta es la clase 'HomePage', que extiende de 'StatefulWidget' y representa la página principal de la aplicación
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Esta es la clase '_HomePageState', que extiende de 'State<HomePage>' y representa el estado de la página principal de la aplicación
class _HomePageState extends State<HomePage> {
 
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Un botón para abrir el escáner de código de barras
            ElevatedButton(
              onPressed: () async {
                /// Navega a la página del escáner de código de barras y obtiene el resultado
                var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
                    ));
                setState(() {
                  /// Si el resultado es una cadena, asigna el resultado a la variable de resultado
                  if (res is String) {
                    result = res;
                  }
                });
              },
              child: const Text('Open Scanner'),
            ),
          

            /// Muestra el resultado del escaneo de código de barras
            Text('Barcode Result: $result'),
                 ElevatedButton( child: const Text("cronometro"),//el boton , y como se llamara el boton
             onPressed: ()=>{//onPressed, quiere decir que cuando se precione se ejecutara lo siguiente
             if(result !=' '){
              Navigator.push(
                context,
                MaterialPageRoute(builder:(context) =>const Crono())//le decimos a que ruta queremos que se vaya.con el nombre de class de widget de la otra pág en este caso 'opcion'
              )
             }
             })
          ],
        ),
      ),
    );
  }

  
}
