import 'dart:math';

class AsyncService {
  // Simula una consulta a API que puede devolver datos o fallar
  Future<List<String>> fetchProductos() async {
    print('⌛ Iniciando fetchProductos...');

    // Simula delay aleatorio entre 2-3 segundos
    final delay = 2000 + Random().nextInt(1000);
    await Future.delayed(Duration(milliseconds: delay));

    // 30% de probabilidad de error para simular fallos
    if (Random().nextDouble() < 0.3) {
      print('❌ Error en fetchProductos: Fallo de red simulado');
      throw Exception('Error de conexión simulado');
    }

    print('✅ fetchProductos completado exitosamente');
    return [
      '📱 iPhone 14 Pro',
      '💻 MacBook Air M2',
      '⌚ Apple Watch Series 8',
      '🎧 AirPods Pro',
      '🖥️ iMac 24"',
      '📱 iPad Pro',
    ];
  }

  // Simula una consulta que siempre tiene éxito pero toma tiempo
  Future<String> getVersion() async {
    print('⌛ Consultando versión...');
    await Future.delayed(const Duration(seconds: 2));
    print('✅ Versión obtenida');
    return 'v2.0.0';
  }

  // Simula una operación que siempre falla después de un delay
  Future<void> simulateError() async {
    print('⌛ Operación que fallará...');
    await Future.delayed(const Duration(seconds: 2));
    print('❌ Error simulado ocurrido');
    throw Exception('Error simulado para pruebas');
  }
}
