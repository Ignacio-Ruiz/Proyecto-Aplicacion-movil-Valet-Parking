import 'dart:async';
import 'package:appvalet/models/crono.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }



  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('App valet')),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        
                        ElevatedButton(
                            onPressed: () => scanQR(),
                            child: Text('Start QR scan')),
                        Text('Scan result : $_scanBarcode\n',
                            style: TextStyle(fontSize: 15)),

                            ElevatedButton( child: const Text("cronometro"),//el boton , y como se llamara el boton
             onPressed:  ()  async {//onPressed, quiere decir que cuando se precione se ejecutara lo siguiente
                
                 var productosData;
                 var hora;
                 var minuto;
                 var time;           
                  http.Response response =
                  await http.get(Uri.parse(_scanBarcode)); //cambiar por result qr
              setState(() {
                productosData = json.decode(response.body);
              
                print(productosData['time']);
                time = productosData['time'];
                
              });
               
               if(_scanBarcode !=' '){ //cambiar despues
              Navigator.push(
                context,
                MaterialPageRoute(builder:(context) => Crono(time))
                //le decimos a que ruta queremos que se vaya.con el nombre de class de widget de la otra pág en este caso 'opcion'
              );
             }
  
             })
                      ]));
            })));
  }
}