import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:http/http.dart' as http;

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
          appBar: AppBar(title: const Text("valet parking")),
          body: const Center(
            child: const Home(),
          ),
        ));
  }

  Future getUsuarios() async {
    final res = await http.get(Uri.parse(result));
    final objetos = jsonDecode(res.body);
    final lista = List.from(objetos);
  }
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
          ],
        ),
      ),
    );
  }
}

/// Esta es la clase 'Home', que extiende de 'StatefulWidget' y representa la pantalla del cronómetro
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  void _setStopwatchText() {
    _stopwatchText = _stopWatch.elapsed.inHours.toString().padLeft(2, '0') +
        ':' +
        (_stopWatch.elapsed.inMinutes % 60).toString().padLeft(2, '0') +
        ':' +
        (_stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');

    _stopwatchText2 = 'precio actual ' +
        (((_stopWatch.elapsed.inHours) * 60 +
                    (_stopWatch.elapsed.inMinutes) % 60) *
                20)
            .toString();
    /*if (double.parse(_stopwatchText2)>30*20) {
    _stopwatchText2="no hay cobro";
    
  } */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cronometro'),
      ),
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
                    style: TextStyle(fontSize: 72),
                  ),
                  Text(
                    _stopwatchText2,
                    style: TextStyle(fontSize: 72),
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
