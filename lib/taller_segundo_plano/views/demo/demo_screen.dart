import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../services/data_service.dart';
import '../../widgets/base_view.dart';

enum FutureStateStatus { idle, loading, success, error }

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  // --- Future / async demo ---
  final DataService _dataService = DataService();
  FutureStateStatus _futureStatus = FutureStateStatus.idle;
  List<String> _items = [];
  String? _futureError;

  // --- Timer / cronómetro ---
  Timer? _timer;
  int _elapsedMs = 0; // milliseconds
  bool _isRunning = false;

  // --- Isolate / heavy task ---
  String _isolateResult = 'Presiona Ejecutar tarea pesada';
  bool _isolateWorking = false;

  // --- Future demo: carga con async/await y estados ---
  Future<void> _loadData() async {
    setState(() {
      _futureStatus = FutureStateStatus.loading;
      _items = [];
      _futureError = null;
    });

    // Imprimir orden de ejecución
    debugPrint('Antes de iniciar fetchData');

    // Llamada al servicio, no await aún para mostrar el "durante"
    final future = _dataService.fetchData();
    debugPrint('Durante: la petición está en vuelo (esperando el Future)');

    try {
      final data = await future; // await sin bloquear la UI
      debugPrint('Después: fetchData completado');
      if (!mounted) return;
      setState(() {
        _futureStatus = FutureStateStatus.success;
        _items = data;
      });
    } catch (e) {
      debugPrint('Después (error): $e');
      if (!mounted) return;
      setState(() {
        _futureStatus = FutureStateStatus.error;
        _futureError = e.toString();
      });
    }
  }

  // --- Timer controls ---
  void _startTimer() {
    if (_isRunning) return;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (t) {
      setState(() {
        _elapsedMs += 1000;
      });
    });
    setState(() {
      _isRunning = true;
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resumeTimer() {
    if (_isRunning) return;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (t) {
      setState(() {
        _elapsedMs += 1000;
      });
    });
    setState(() {
      _isRunning = true;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _elapsedMs = 0;
      _isRunning = false;
    });
  }

  String _formatElapsed(int ms) {
    final totalSeconds = ms ~/ 1000;
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // --- Isolate heavy task ---
  Future<void> _runHeavyTaskInIsolate() async {
    if (_isolateWorking) return;
    setState(() {
      _isolateWorking = true;
      _isolateResult = 'Iniciando tarea en isolate...';
    });

    final receivePort = ReceivePort();

    try {
      // Spawn isolate
      await Isolate.spawn(_isolateEntry, receivePort.sendPort);

      // The spawned isolate will first send a SendPort we can use to communicate
      final sendPort = await receivePort.first as SendPort;

      // Create a port for the response
      final responsePort = ReceivePort();

      // Choose a work size (a number large enough to be CPU-bound but reasonable)
      final workItems = 10000000; // 10 million

      // Send the work request
      sendPort.send([workItems, responsePort.sendPort]);

      // Wait for the result with a timeout
      final result = await responsePort.first.timeout(
        const Duration(seconds: 20),
        onTimeout: () => 'timeout',
      );

      if (!mounted) return;
      if (result == 'timeout') {
        setState(() {
          _isolateResult = 'Timeout: el isolate no respondió a tiempo';
        });
      } else {
        setState(() {
          _isolateResult = 'Resultado: $result';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isolateResult = 'Error ejecutando isolate: $e';
      });
    } finally {
      receivePort.close();
      setState(() {
        _isolateWorking = false;
      });
    }
  }

  // Entry point for the spawned isolate
  static void _isolateEntry(SendPort mainSendPort) async {
    final port = ReceivePort();
    // Send the SendPort to the main isolate so it can communicate
    mainSendPort.send(port.sendPort);

    await for (final message in port) {
      final args = message as List<dynamic>;
      final int n = args[0] as int;
      final SendPort reply = args[1] as SendPort;

      // CPU-bound work: sum 1..n
      int counter = 0;
      for (int i = 1; i <= n; i++) {
        counter += i;
      }

      // Send the result back
      reply.send(counter);

      // Close and exit
      port.close();
      Isolate.exit();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Demo: Future / Timer / Isolate',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Future card ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '1) Future / async / await',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Simula una consulta (2–3s). Muestra estados: Cargando / Éxito / Error.',
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _loadData,
                          child: const Text('Cargar datos'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _futureStatus = FutureStateStatus.idle;
                              _items = [];
                              _futureError = null;
                            });
                          },
                          child: const Text('Limpiar'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildFutureContent(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // --- Timer card ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '2) Timer / Cronómetro',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatElapsed(_elapsedMs),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: _startTimer,
                          child: const Text('Iniciar'),
                        ),
                        ElevatedButton(
                          onPressed: _pauseTimer,
                          child: const Text('Pausar'),
                        ),
                        ElevatedButton(
                          onPressed: _resumeTimer,
                          child: const Text('Reanudar'),
                        ),
                        ElevatedButton(
                          onPressed: _resetTimer,
                          child: const Text('Reiniciar'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'El timer actualiza cada 1s y se cancela al pausar o salir.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // --- Isolate card ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '3) Isolate / Tarea pesada',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ejecuta una tarea CPU-bound en un isolate y muestra el resultado.',
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _isolateWorking
                              ? null
                              : _runHeavyTaskInIsolate,
                          child: const Text('Ejecutar tarea pesada'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isolateResult = 'Presiona Ejecutar tarea pesada';
                            });
                          },
                          child: const Text('Limpiar'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(_isolateResult),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFutureContent() {
    switch (_futureStatus) {
      case FutureStateStatus.idle:
        return const Text('Estado: Inactivo');
      case FutureStateStatus.loading:
        return Row(
          children: const [
            CircularProgressIndicator(),
            SizedBox(width: 12),
            Text('Cargando...'),
          ],
        );
      case FutureStateStatus.success:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Éxito: datos recibidos:'),
            const SizedBox(height: 8),
            for (final item in _items) Text('- $item'),
          ],
        );
      case FutureStateStatus.error:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Error: ${_futureError ?? 'desconocido'}',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Reintentar'),
            ),
          ],
        );
    }
  }
}
