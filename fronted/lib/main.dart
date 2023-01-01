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
  String _scanBarcode2 = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.QR);
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
      if (_scanBarcode !="Unknown") {
        print("es distinto");
        _scanBarcode2="codigo qr leido";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: const Center(
                  child: Text('Valet Parking', textAlign: TextAlign.center)),
              backgroundColor: Colors.redAccent,
            ),
            
            body: Builder(builder: (BuildContext context) {
              return Container(
                
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'images/fondo.jpg'), // establece la imagen de fondo del Container
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Lector QR",
                         style: const TextStyle(
                              fontSize: 20, color: Colors.white)),
                        ElevatedButton(
                            onPressed: () => scanQR(),
                            
                            child: const Text('Escanear')),
                        Text (

                          'Escaner : $_scanBarcode2\n',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                        Text("Cronometro para tiempo", style: const TextStyle(
                              fontSize: 20, color: Colors.white)),
                        ElevatedButton(
                            child: const Text(
                                "Verificación"), //el boton , y como se llamara el boton
                            onPressed: () async {
                              //onPressed, quiere decir que cuando se precione se ejecutara lo siguiente

                              var productosData;
                              var hora;
                              var minuto;
                              var time;
                              http.Response response = await http.get(Uri.parse(
                                  _scanBarcode)); //cambiar por result qr
                              setState(() {
                                productosData = json.decode(response.body);

                                print(productosData['time']);
                                time = productosData['time'];
                              });

                              if (_scanBarcode != ' ') {
                                //cambiar despues
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Crono(time))
                                    //le decimos a que ruta queremos que se vaya.con el nombre de class de widget de la otra pág en este caso 'opcion'
                                    );
                              }
                            })
                      ]));
            })));
  }
}
