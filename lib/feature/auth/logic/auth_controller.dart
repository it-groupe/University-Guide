import 'package:flutter/foundation.dart';

class AuthController extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isGuest = false;

  String? _displayName;
  String? _email;

  bool get isLoggedIn => _isLoggedIn;
  bool get isGuest => _isGuest;

  String get displayName => _displayName ?? (_isGuest ? 'زائر' : 'مستخدم');
  String? get email => _email;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    // الآن: دخول مباشر (بدون تحقق) - لاحقًا تربطه بـ API/DB
    _isLoggedIn = true;
    _isGuest = false;

    // ✅ نخزن اسم للعرض من username
    _displayName = username.trim().isEmpty ? 'مستخدم' : username.trim();
    _email = null;

    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // الآن: تسجيل مباشر - لاحقًا تربطه بـ API/DB + app_user
    _isLoggedIn = true;
    _isGuest = false;

    // ✅ نخزن الاسم والإيميل
    _displayName = name.trim().isEmpty ? 'مستخدم' : name.trim();
    _email = email.trim().isEmpty ? null : email.trim();

    notifyListeners();
  }

  Future<void> loginAsGuest() async {
    _isLoggedIn = true;
    _isGuest = true;

    _displayName = 'زائر';
    _email = null;

    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _isGuest = false;
    _displayName = null;
    _email = null;
    notifyListeners();
  }
}
