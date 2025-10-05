import 'dart:async';
import 'package:flutter/material.dart';
import '../../widgets/base_view.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? _timer;
  int _milliseconds = 0;
  bool _isRunning = false;

  // Inicia o reanuda el timer
  void _startTimer() {
    if (_isRunning) return;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _milliseconds += 100;
      });
    });
    setState(() {
      _isRunning = true;
    });
  }

  // Pausa el timer
  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  // Reinicia el timer a cero
  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _milliseconds = 0;
      _isRunning = false;
    });
  }

  // Formatea el tiempo para mostrar minutos:segundos.milisegundos
  String _formatTime() {
    final minutes = (_milliseconds ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((_milliseconds % 60000) ~/ 1000).toString().padLeft(
      2,
      '0',
    );
    final ms = ((_milliseconds % 1000) ~/ 100).toString();
    return '$minutes:$seconds.$ms';
  }

  @override
  void dispose() {
    // Limpieza de recursos: cancela el timer al salir
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Cronómetro',
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
              Theme.of(context).colorScheme.secondary.withOpacity(0.3),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display del cronómetro
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  _formatTime(),
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'monospace',
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              // Botones de control
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildControlButton(
                    icon: _isRunning ? Icons.pause : Icons.play_arrow,
                    label: _isRunning ? 'Pausar' : 'Iniciar',
                    onPressed: _isRunning ? _pauseTimer : _startTimer,
                    color: _isRunning ? Colors.orange : Colors.green,
                  ),
                  const SizedBox(width: 24),
                  _buildControlButton(
                    icon: Icons.restart_alt,
                    label: 'Reiniciar',
                    onPressed: _resetTimer,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Indicador de estado
              Text(
                _isRunning ? 'Cronómetro en marcha' : 'Cronómetro detenido',
                style: TextStyle(
                  fontSize: 16,
                  color: _isRunning ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
