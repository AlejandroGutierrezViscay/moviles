import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthService {
  final String baseUrl = dotenv.env['URL_API_REGISTRO_CLASES']!;
  //! flutter_secure_storage para guardar el token de forma segura
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  //! login se encarga de autenticar al usuario
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Simular delay de red
      await Future.delayed(const Duration(seconds: 1));
      
      // Verificar si el usuario existe
      final prefs = await SharedPreferences.getInstance();
      final registeredUsers = prefs.getStringList('registered_users') ?? [];
      
      if (!registeredUsers.contains(email)) {
        return {
          'success': false,
          'message': 'Usuario no encontrado. ¿Ya te registraste?',
        };
      }

      // Obtener datos del usuario
      final userDataString = prefs.getString('user_data_$email');
      if (userDataString == null) {
        return {
          'success': false,
          'message': 'Error al cargar datos del usuario',
        };
      }

      final userData = jsonDecode(userDataString);
      
      // Verificar contraseña
      if (userData['password'] != password) {
        return {
          'success': false,
          'message': 'Contraseña incorrecta',
        };
      }

      // Generar token JWT simulado
      final now = DateTime.now();
      final token = 'jwt_token_${now.millisecondsSinceEpoch}_${userData['id']}';
      
      try {
        // Guardar token de forma segura con flutter_secure_storage
        await _secureStorage.write(key: 'token', value: token);
        await _secureStorage.write(key: 'token_type', value: 'Bearer');
        await _secureStorage.write(key: 'expires_in', value: '86400'); // 24 horas

        // Guardar datos del usuario con shared_preferences (no sensibles)
        await prefs.setString('user_name', userData['name']);
        await prefs.setString('user_email', userData['email']);
        await prefs.setInt('user_id', userData['id']);
        
        return {
          'success': true, 
          'message': 'Login exitoso',
          'user': User(
            id: userData['id'],
            name: userData['name'],
            email: userData['email'],
          ),
          'token': token,
        };
      } catch (e) {
        debugPrint('Error al guardar credenciales: $e');
        return {
          'success': false,
          'message': 'Error al guardar credenciales localmente',
        };
      }
    } catch (e) {
      debugPrint('Exception en login: $e');
      return {
        'success': false,
        'message': 'Error de conexión. Verifica tu internet.',
      };
    }
  }

  //! getUser se encarga de obtener el usuario desde SharedPreferences
  Future<User?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getInt('user_id');
      final name = prefs.getString('user_name');
      final email = prefs.getString('user_email');

      if (id != null && name != null && email != null) {
        return User(id: id, name: name, email: email);
      }
    } catch (e) {
      debugPrint('Error al obtener usuario: $e');
    }
    return null;
  }

  //! getToken se encarga de obtener el token desde flutter_secure_storage
  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: 'token');
    } catch (e) {
      debugPrint('Error al obtener token: $e');
      return null;
    }
  }

  //! logout elimina el token y los datos del usuario
  Future<void> logout() async {
    try {
      //* Eliminar token de flutter_secure_storage
      await _secureStorage.delete(key: 'token');
      await _secureStorage.delete(key: 'token_type');
      await _secureStorage.delete(key: 'expires_in');

      //* Eliminar datos del usuario de SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
      await prefs.remove('user_name');
      await prefs.remove('user_email');
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  //! isLoggedIn verifica si el usuario tiene un token válido
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  //! getAuthHeader retorna el header de autenticación para las peticiones
  Future<Map<String, String>> getAuthHeader() async {
    final token = await getToken();
    final tokenType = await _secureStorage.read(key: 'token_type') ?? 'bearer';

    if (token != null) {
      return {
        'Authorization':
            '${tokenType.substring(0, 1).toUpperCase()}${tokenType.substring(1)} $token',
        'Content-Type': 'application/json',
      };
    }
    return {'Content-Type': 'application/json'};
  }

  //! register se encarga de registrar un nuevo usuario
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      // Simular delay de red
      await Future.delayed(const Duration(seconds: 1));
      
      // Validaciones básicas
      if (password != passwordConfirmation) {
        return {
          'success': false,
          'message': 'Las contraseñas no coinciden',
          'errors': {'password_confirmation': ['Las contraseñas no coinciden']},
        };
      }
      
      if (password.length < 6) {
        return {
          'success': false,
          'message': 'La contraseña debe tener al menos 6 caracteres',
          'errors': {'password': ['Mínimo 6 caracteres']},
        };
      }

      // Verificar si el email ya existe (simulado)
      final prefs = await SharedPreferences.getInstance();
      final existingUsers = prefs.getStringList('registered_users') ?? [];
      
      if (existingUsers.contains(email)) {
        return {
          'success': false,
          'message': 'El email ya está registrado',
          'errors': {'email': ['Email ya registrado']},
        };
      }

      // Registrar usuario (simulado)
      existingUsers.add(email);
      await prefs.setStringList('registered_users', existingUsers);
      
      // Guardar datos del usuario
      await prefs.setString('user_data_$email', jsonEncode({
        'id': DateTime.now().millisecondsSinceEpoch,
        'name': name,
        'email': email,
        'password': password, // En producción esto estaría hasheado
        'created_at': DateTime.now().toIso8601String(),
      }));

      return {
        'success': true,
        'message': 'Usuario registrado exitosamente. Ya puedes iniciar sesión.',
        'user': User(
          id: DateTime.now().millisecondsSinceEpoch,
          name: name,
          email: email,
        ),
      };
    } catch (e) {
      debugPrint('Error en registro: $e');
      return {
        'success': false,
        'message': 'Error al registrar usuario. Inténtalo de nuevo.',
      };
    }
  }

  //! getUserInfo obtiene información del usuario desde shared_preferences
  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('user_name');
      final email = prefs.getString('user_email');
      final id = prefs.getInt('user_id');

      if (name != null && email != null && id != null) {
        return {
          'id': id,
          'name': name,
          'email': email,
        };
      }
      return null;
    } catch (e) {
      debugPrint('Error obteniendo info del usuario: $e');
      return null;
    }
  }

  //! getSessionStatus obtiene el estado de la sesión para la vista de evidencia
  Future<Map<String, dynamic>> getSessionStatus() async {
    try {
      final token = await getToken();
      final userInfo = await getUserInfo();

      return {
        'hasToken': token != null && token.isNotEmpty,
        'tokenPresent': token != null ? 'Token presente' : 'Sin token',
        'userInfo': userInfo,
        'tokenType': await _secureStorage.read(key: 'token_type'),
        'expiresIn': await _secureStorage.read(key: 'expires_in'),
      };
    } catch (e) {
      debugPrint('Error obteniendo estado de sesión: $e');
      return {
        'hasToken': false,
        'tokenPresent': 'Error al verificar token',
        'userInfo': null,
      };
    }
  }
}
