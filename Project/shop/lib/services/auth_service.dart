import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // Initialize SharedPreferences
  Future<SharedPreferences> _getPrefs() async => await SharedPreferences.getInstance();

  // Store email and password (web uses localStorage)
  Future<void> storeCredentials(String email, String password) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setString('email', email);
      await prefs.setString('password', password);
    } catch (e) {
      print('Error storing credentials: $e');
      rethrow;
    }
  }

  // Relogin using stored credentials
  Future<User?> relogin() async {
    try {
      final prefs = await _getPrefs();
      String? email = prefs.getString('email');
      String? password = prefs.getString('password');

      if (email != null && password != null) {
        final response = await Supabase.instance.client.auth.signInWithPassword(
          email: email,
          password: password,
        );
        return response.user;
      }
      return null;
    } catch (e) {
      print('Error during relogin: $e');
      return null;
    }
  }

  // Clear stored credentials
  Future<void> clearCredentials() async {
    try {
      final prefs = await _getPrefs();
      await prefs.remove('email');
      await prefs.remove('password');
    } catch (e) {
      print('Error clearing credentials: $e');
    }
  }
}