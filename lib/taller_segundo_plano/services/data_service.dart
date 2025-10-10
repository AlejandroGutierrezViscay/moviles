import 'dart:math';

class DataService {
  Future<List<String>> fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    if (Random().nextBool()) {
      throw Exception('Error simulado al cargar datos');
    }
    return ['Dato 1', 'Dato 2', 'Dato 3'];
  }

  Future<int> heavyComputation(int n) async {
    int result = 0;
    for (int i = 0; i < n; i++) {
      result += i;
    }
    return result;
  }
}
