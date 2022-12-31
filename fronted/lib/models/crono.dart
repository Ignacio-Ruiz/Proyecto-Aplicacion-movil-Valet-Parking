import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class Crono extends StatefulWidget {
  
  Crono(this.time);
  String time;

  


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

  Function(){

  }
  
  Future<void> _setStopwatchText() async {

     

    var precio;

        http.Response response =
        await http.get(Uri.parse('http://localhost:3000/api/vars/all'));
    setState(() {
      productosData = json.decode(response.body);
    
     // print(productosData[0]['precioM']);
      precio=productosData[0]['precioM'];
      //print(precio);
      
    });
     //print(int.parse(precio));
    //print(widget.time);
    var time=widget.time;
    var hora;
    var minuto;
    time.toString();
    //print(time.split(":")[0]);
    //print(time.split(":")[1]);
     hora =time.split(":")[0];
     minuto = time.split(":")[1];

      final now = DateTime.now();
      //print(now.hour);
     // print(now.minute);
      var horaactual = now.hour;
      var minutoactual = now.minute;

    //print(horaactual-int.parse(hora));
    //print((minutoactual-int.parse(minuto)).abs());  
    var diferenciaH = (horaactual-int.parse(hora)).abs();
    var diferenciaM = (minutoactual-int.parse(minuto)).abs();

    _stopwatchText = (_stopWatch.elapsed.inHours+diferenciaH).toString().padLeft(2,'0') + ':'+
                     ((_stopWatch.elapsed.inMinutes%60)+diferenciaM).toString().padLeft(2,'0') + ':' +
                     (_stopWatch.elapsed.inSeconds%60).toString().padLeft(2,'0');

  

 
  if (diferenciaH>=1 || diferenciaM>=30 || ((_stopWatch.elapsed.inMinutes%60)+diferenciaM)>=30) {
    print(diferenciaH);
    _stopwatchText2= 'precio actual ' +(((_stopWatch.elapsed.inHours+diferenciaH)*60+(_stopWatch.elapsed.inMinutes+diferenciaM)%60)*int.parse(precio)).toString();
    
  } 
  else{
  _stopwatchText2 = "no hay cobro los primeros 30 minutos";
    
  }          
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
              
              style: TextStyle(fontSize: 60),
            ),Text(
              _stopwatchText2,
               style: TextStyle(fontSize: 60),
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

