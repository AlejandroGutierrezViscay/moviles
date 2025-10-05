import 'package:flutter/material.dart';
import '../../services/async_service.dart';
import '../../widgets/base_view.dart';

class AsyncDemoScreen extends StatefulWidget {
  const AsyncDemoScreen({super.key});

  @override
  State<AsyncDemoScreen> createState() => _AsyncDemoScreenState();
}

class _AsyncDemoScreenState extends State<AsyncDemoScreen> {
  final AsyncService _service = AsyncService();

  // Estados para cada operación
  bool _isLoadingProducts = false;
  bool _isLoadingVersion = false;
  bool _isSimulatingError = false;

  List<String>? _products;
  String? _version;
  String? _error;

  // Cargar productos con manejo de estados
  Future<void> _loadProducts() async {
    // Resetear estados
    setState(() {
      _isLoadingProducts = true;
      _products = null;
      _error = null;
    });

    print('🚀 ANTES: Iniciando carga de productos');

    try {
      // No usamos await inmediatamente para poder mostrar el "DURANTE"
      final future = _service.fetchProductos();
      print('⏳ DURANTE: La petición está en vuelo');

      // Ahora sí esperamos el resultado
      final products = await future;

      print('✅ DESPUÉS: Productos cargados exitosamente');

      if (!mounted) return;
      setState(() {
        _products = products;
        _isLoadingProducts = false;
      });
    } catch (e) {
      print('❌ DESPUÉS: Error cargando productos - $e');
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoadingProducts = false;
      });
    }
  }

  // Cargar versión (siempre exitosa)
  Future<void> _loadVersion() async {
    setState(() {
      _isLoadingVersion = true;
      _version = null;
    });

    try {
      final version = await _service.getVersion();
      if (!mounted) return;
      setState(() {
        _version = version;
        _isLoadingVersion = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingVersion = false;
      });
    }
  }

  // Simular error
  Future<void> _simulateError() async {
    setState(() {
      _isSimulatingError = true;
      _error = null;
    });

    try {
      await _service.simulateError();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSimulatingError = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Demo: Future/async/await',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProductsSection(),
            const SizedBox(height: 24),
            _buildVersionSection(),
            const SizedBox(height: 24),
            _buildErrorSection(),
            if (_error != null) ...[
              const SizedBox(height: 24),
              _buildErrorMessage(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProductsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '1. Cargar Productos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Simula una carga de 2-3s con 30% de probabilidad de error.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoadingProducts ? null : _loadProducts,
              child: const Text('Cargar Productos'),
            ),
            const SizedBox(height: 16),
            if (_isLoadingProducts)
              const Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Cargando productos...'),
                ],
              )
            else if (_products != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Productos cargados:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._products!.map(
                    (product) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(product),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '2. Consultar Versión',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Operación que siempre tiene éxito después de 2s.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoadingVersion ? null : _loadVersion,
              child: const Text('Consultar Versión'),
            ),
            const SizedBox(height: 16),
            if (_isLoadingVersion)
              const Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Consultando versión...'),
                ],
              )
            else if (_version != null)
              Text(
                'Versión actual: $_version',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '3. Simular Error',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Operación que siempre falla después de 2s.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSimulatingError ? null : _simulateError,
              child: const Text('Simular Error'),
            ),
            if (_isSimulatingError) ...[
              const SizedBox(height: 16),
              const Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Simulando error...'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade700),
                const SizedBox(width: 8),
                const Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(_error!, style: TextStyle(color: Colors.red.shade700)),
          ],
        ),
      ),
    );
  }
}
