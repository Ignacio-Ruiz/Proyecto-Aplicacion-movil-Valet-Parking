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
  Future<Map> getTodoList() async {
    try {
      var response = await Dio().get(
          ('http://10.0.2.2:3000/api/vars/all')); //resivimos los datos del api para sacar el precio del api
      print(response.data);
      print("hola");

      return response.data;
    } catch (e) {
      return <String, Object>{};
    }
  }

  bool _isStart = true;
  String _stopwatchText = '00:00:00';
  String _stopwatchText2 = " ";
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

  Function() {}

  Future<void> _setStopwatchText() async {
    var precio;
    //se piden los datos desde la api 
    http.Response response =
        await http.get(Uri.parse('http://10.0.2.2:3000/api/vars/all'));
    setState(() {
      productosData = json.decode(response.body);
      //los print comentados fueron para probar los datos que se reciven desde el api

      // print(productosData[0]['precioM']);
      precio = productosData[0]['precioM'];
      //print(precio);
    });
    //print(int.parse(precio));
    //print(widget.time);
    var time = widget.time;
    var hora;
    var minuto;
    time.toString();
    //Se separa entre horas y minutos

    //print(time.split(":")[0]);
    //print(time.split(":")[1]);
    hora = time.split(":")[0];
    minuto = time.split(":")[1];

    //funcion para sacar la hora actual del dispositivo
    final now = DateTime.now();
    //print(now.hour);
    // print(now.minute);
    var horaactual = now.hour;
    var minutoactual = now.minute;

    //Se saca la resta en valor absoluto para agregarlos al cronometro

    //print(horaactual-int.parse(hora).abs);
    //print((minutoactual-int.parse(minuto)).abs());
    var diferenciaH = (horaactual - int.parse(hora)).abs();
    var diferenciaM = (minutoactual - int.parse(minuto)).abs();

//Funcion de cronometro
    _stopwatchText =
        (_stopWatch.elapsed.inHours + diferenciaH).toString().padLeft(2, '0') +
            ':' +
            ((_stopWatch.elapsed.inMinutes % 60) + diferenciaM)
                .toString()
                .padLeft(2, '0') +
            ':' +
            (_stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');

//ve si la diferencia entre la hora actual y la hora que esta en el backend supera 1 hora o 30 mintuos tambien 
//en caso de que empiece en ceros esta la funcion que ve cuando supere los 30 minutos
    if (diferenciaH >= 1 ||
        diferenciaM >= 30 ||
        ((_stopWatch.elapsed.inMinutes % 60) + diferenciaM) >= 30) {
      print(diferenciaH);
      _stopwatchText2 = 'Precio actual: ' +
          (((_stopWatch.elapsed.inHours + diferenciaH) * 60 +
                      (_stopWatch.elapsed.inMinutes + diferenciaM) % 60) *
                  int.parse(precio))
              .toString();
    } else {
      _stopwatchText2 = "No hay cobro los primeros 30 minutos";
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
              child: Column(
                children: [
                  Text(
                    _stopwatchText,
                    style: TextStyle(fontSize: 60),
                  ),
                  Text(
                    _stopwatchText2,
                    style: TextStyle(fontSize: 27),
                  ),
                ],
              )),
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
