import 'dart:async';
import 'dart:convert';
//import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
//import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
//import 'package:http/http.dart';

//import 'package:http/retry.dart';

import '../main.dart';

//import 'dart:convert';
import 'package:http/http.dart' as http;







class Crono extends StatefulWidget {
  const Crono({super.key});

  @override
  State<Crono> createState() => _Crono();

}

class _Crono extends State<Crono> {

 var productosData;


   getProductos() async {
    http.Response response =
        await http.get(Uri.parse('http://localhost:3000/api/vars/all'));
    setState(() {
      productosData = json.decode(response.body) as List;
      print(productosData);
    });
  }

  Future<Map> getTodoList() async {
  try {
    var response = await Dio().get(('http://localhost:3000/api/vars/all'));//resivimos los datos del api para sacar el precio del api
    print(response.data);
    print("hola");
    
    return response.data;
      } catch (e) {
    return <String, Object>{};
    }
  }



  bool _isStart = true;
  String _stopwatchText = '00:00:00';
  String _stopwatchText2=" ";
  final _stopWatch = new Stopwatch();
  final _timeout = const Duration(seconds: 1);

  /// Inicia el temporizador para actualizar el cronómetro cada vez que expire
  void _startTimeout() {
    new Timer(_timeout, _handleTimeout);
  }

  /// Maneja el evento de expiración del temporizador y actualiza el cronómetro si está en estado "iniciado"
  void _handleTimeout() {
    if (_stopWatch.isRunning) {
      _startTimeout();
    }
    setState(() {
      _setStopwatchText();
    });
  }

  /// Maneja el evento de presión del botón "Iniciar/Detener"
  void _startStopButtonPressed() {
    setState(() {
      if (_stopWatch.isRunning) {
        _isStart = true;
        _stopWatch.stop();
      } else {
        _isStart = false;
        _stopWatch.start();
        _startTimeout();
      }
    });
  }

  /// Maneja el evento de presión del botón "Reiniciar"
  void _resetButtonPressed() {
    if (_stopWatch.isRunning) {
      _startStopButtonPressed();
    }
    setState(() {
     _stopWatch.reset();
     _setStopwatchText(); 
    });
  }

  Future<void> _setStopwatchText() async {

        http.Response response =
        await http.get(Uri.parse('http://localhost:3000/api/vars/all'));
    setState(() {
      productosData = json.decode(response.body);
      print(productosData['precioM']);
      
    });
    
  
    _stopwatchText = _stopWatch.elapsed.inHours.toString().padLeft(2,'0') + ':'+
                     (_stopWatch.elapsed.inMinutes%60).toString().padLeft(2,'0') + ':' +
                     (_stopWatch.elapsed.inSeconds%60).toString().padLeft(2,'0');

  _stopwatchText2= 'precio actual ' +(((_stopWatch.elapsed.inHours)*60+(_stopWatch.elapsed.inMinutes)%60)*20).toString();
  /*if (double.parse(_stopwatchText2)>30*20) {
    _stopwatchText2="no hay cobro";
    
  } */             
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
  
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
                Expanded(
          child: FittedBox(
            fit: BoxFit.none,
            child: Column(children: [Text(

              _stopwatchText,
              
              style: TextStyle(fontSize: 72),
            ),Text(
              _stopwatchText2,
               style: TextStyle(fontSize: 72),
            ),
            ],)
          ),
        ),
        Center(          
          child: Column(            
            children: <Widget>[
              /// Un botón con un icono de "play" o "stop", dependiendo del estado del cronómetro
              ElevatedButton(
                child: Icon(_isStart ? Icons.play_arrow : Icons.stop),
                onPressed: _startStopButtonPressed,
              ),
              ElevatedButton(
                child: Text('Reset'),
                onPressed: _resetButtonPressed,
              ),
            ],
          ),
        ),

      ],
    );
  }
}

