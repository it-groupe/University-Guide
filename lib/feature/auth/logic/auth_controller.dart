import 'package:flutter/foundation.dart';

import 'package:flutter_application_9/core/cache/cache_keys.dart';
import 'package:flutter_application_9/core/cache/cache_store.dart';
import 'package:flutter_application_9/core/network/api_client.dart';
import 'package:flutter_application_9/core/network/api_endpoints.dart';
import 'package:flutter_application_9/core/utils/json_utils.dart';

class AuthController extends ChangeNotifier {
  final ApiClient api;
  final CacheStore cache;

  AuthController({required this.api, required this.cache});

  bool _isLoggedIn = false;
  bool _isGuest = false;

  bool isLoading = false;
  String? lastError;

  int? _user_id;
  String? _displayName;
  String? _email;
  String? _school;

  bool get isLoggedIn => _isLoggedIn;
  bool get isGuest => _isGuest;

  int? get user_id => _user_id;
  String get displayName => _displayName ?? (_isGuest ? 'زائر' : 'مستخدم');
  String? get email => _email;
  String? get school => _school;

  /// تحميل جلسة محفوظة من الكاش عند تشغيل التطبيق
  Future<void> load_session() async {
    final raw = await cache.read_string(CacheKeys.auth_user);
    if (raw == null) return;

    try {
      final map = decode_json(raw) as Map<String, dynamic>;
      _apply_user_map(map);
      _isLoggedIn = true;
      _isGuest = false;
      notifyListeners();
    } catch (_) {
      // إذا الكاش فاسد احذفه
      await cache.remove(CacheKeys.auth_user);
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final email_input = username.trim();

    isLoading = true;
    lastError = null;
    notifyListeners();

    try {
      final res = await api.post_json(
        '${ApiEndpoints.base_url}${ApiEndpoints.auth_login}',
        body: {'email': email_input, 'password': password},
      );

      if (res['success'] != true) {
        throw Exception((res['message'] ?? 'Login failed').toString());
      }

      final user = Map<String, dynamic>.from(res['data'] as Map);

      _apply_user_map(user);

      _isLoggedIn = true;
      _isGuest = false;

      await cache.write_string(CacheKeys.auth_user, encode_json(user));
    } catch (e) {
      lastError = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    lastError = null;
    notifyListeners();

    try {
      final res = await api.post_json(
        '${ApiEndpoints.base_url}${ApiEndpoints.auth_register}',
        body: {
          'full_name': name.trim(),
          'email': email.trim(),
          'password': password,
          // optional
          'school': _school ?? '',
        },
      );

      if (res['success'] != true) {
        throw Exception((res['message'] ?? 'Register failed').toString());
      }

      final user = Map<String, dynamic>.from(res['data'] as Map);

      _apply_user_map(user);

      _isLoggedIn = true;
      _isGuest = false;

      await cache.write_string(CacheKeys.auth_user, encode_json(user));
    } catch (e) {
      lastError = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginAsGuest() async {
    _isLoggedIn = true;
    _isGuest = true;

    _user_id = null;
    _displayName = 'زائر';
    _email = null;
    _school = null;

    // الزائر لا نخزنه في session
    await cache.remove(CacheKeys.auth_user);

    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _isGuest = false;

    _user_id = null;
    _displayName = null;
    _email = null;
    _school = null;

    await cache.remove(CacheKeys.auth_user);

    notifyListeners();
  }

  void _apply_user_map(Map<String, dynamic> user) {
    _user_id = _as_int_nullable(user['user_id']);
    _displayName = (user['full_name'] ?? user['name'] ?? '').toString();
    _email = (user['email'])?.toString();
    _school = (user['school'])?.toString();
  }

  int? _as_int_nullable(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }
}
