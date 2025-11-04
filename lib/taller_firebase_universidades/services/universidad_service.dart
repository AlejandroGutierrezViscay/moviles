import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/universidad.dart';

class UniversidadService {
  static final _ref = FirebaseFirestore.instance.collection('universidades');

  /// Obtiene una universidad por su ID
  static Stream<Universidad?> watchUniversidadById(String id) {
    return _ref.doc(id).snapshots().map((doc) {
      if (doc.exists) {
        return Universidad.fromMap(doc.id, doc.data()!);
      }
      return null;
    });
  }

  /// Obtiene todas las universidades como Future
  static Future<List<Universidad>> getUniversidades() async {
    final snapshot = await _ref.get();
    return snapshot.docs
        .map((doc) => Universidad.fromMap(doc.id, doc.data()))
        .toList();
  }

  /// Observa los cambios en la colección de universidades en tiempo real
  /// y devuelve una lista de universidades actualizada
  static Stream<List<Universidad>> watchUniversidades() {
    return _ref.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Universidad.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  /// Agrega una nueva universidad
  static Future<void> addUniversidad(Universidad universidad) async {
    await _ref.add(universidad.toMap());
  }

  /// Actualiza una universidad existente
  static Future<void> updateUniversidad(Universidad universidad) async {
    await _ref.doc(universidad.id).update(universidad.toMap());
  }

  /// Obtiene una universidad por su ID como Future
  static Future<Universidad?> getUniversidadById(String id) async {
    final doc = await _ref.doc(id).get();
    if (doc.exists) {
      return Universidad.fromMap(doc.id, doc.data()!);
    }
    return null;
  }

  /// Elimina una universidad
  static Future<void> deleteUniversidad(String id) async {
    await _ref.doc(id).delete();
  }

  /// Busca universidades por nombre (útil para filtros)
  static Stream<List<Universidad>> searchUniversidadesByNombre(String nombre) {
    return _ref
        .where('nombre', isGreaterThanOrEqualTo: nombre)
        .where('nombre', isLessThan: nombre + 'z')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Universidad.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  /// Busca universidades por NIT
  static Stream<List<Universidad>> searchUniversidadesByNit(String nit) {
    return _ref
        .where('nit', isEqualTo: nit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Universidad.fromMap(doc.id, doc.data()))
          .toList();
    });
  }
}