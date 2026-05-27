import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cafesense/core/network/api_client.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Đăng nhập thất bại.');
      }

      final String token = await user.getIdToken() ?? '';
      final String userId = user.uid;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('userId', userId);
      await prefs.setBool('isLoggedIn', true);
      // Bỏ qua khảo sát, đi thẳng vào trang chủ
      await prefs.setBool('isOnboardingCompleted', true);

      return {
        'token': token,
        'id': userId,
      };
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Đã xảy ra lỗi hệ thống.');
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Đăng ký thất bại.');
      }

      await user.updateDisplayName(name);
      await user.reload();

      final String token = await user.getIdToken() ?? '';
      final String userId = user.uid;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('userId', userId);
      await prefs.setBool('isLoggedIn', true);
      // (Đối với người dùng đăng ký mới, KHÔNG set isOnboardingCompleted = true để họ làm khảo sát)

      return {
        'token': token,
        'id': userId,
      };
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Đã xảy ra lỗi hệ thống.');
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.setBool('isLoggedIn', false);
    await prefs.setBool('isOnboardingCompleted', false);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepository(apiClient);
});
