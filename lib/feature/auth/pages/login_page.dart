import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_9/app/navigation/main_bottom_nav.dart';
import 'package:flutter_application_9/app/theme/app_color_scheme.dart';
import 'package:flutter_application_9/app/theme/app_gradient_scheme.dart';
import 'package:flutter_application_9/app/theme/app_radius.dart';
import 'package:flutter_application_9/app/theme/app_shadows.dart';
import 'package:flutter_application_9/app/theme/app_spacing.dart';
import 'package:flutter_application_9/app/theme/app_text_styles.dart';
import 'package:flutter_application_9/app/theme/widgets/app_scaffold.dart';
import 'package:flutter_application_9/app/theme/widgets/soft_background_bubbles.dart';

import '../logic/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Login
  final _loginFormKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _loginPass = TextEditingController();
  bool _loginObscure = true;

  // Register
  final _registerFormKey = GlobalKey<FormState>();
  final _regName = TextEditingController();
  final _regEmail = TextEditingController();
  final _regPass = TextEditingController();
  bool _regObscure = true;

  int _tabIndex = 0; // 0 login, 1 register

  static const String _logoAssetPath = 'assets/images/logo.png';

  @override
  void dispose() {
    _username.dispose();
    _loginPass.dispose();
    _regName.dispose();
    _regEmail.dispose();
    _regPass.dispose();
    super.dispose();
  }

  Future<void> _goHome() async {
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const MainBottomNav()));
  }

  Future<void> _login() async {
    if (!(_loginFormKey.currentState?.validate() ?? false)) return;

    final auth = context.read<AuthController>();
    await auth.login(
      username: _username.text.trim(),
      password: _loginPass.text,
    );
    await _goHome();
  }

  Future<void> _register() async {
    if (!(_registerFormKey.currentState?.validate() ?? false)) return;

    final auth = context.read<AuthController>();
    await auth.register(
      name: _regName.text.trim(),
      email: _regEmail.text.trim(),
      password: _regPass.text,
    );
    await _goHome();
  }

  Future<void> _guest() async {
    final auth = context.read<AuthController>();
    await auth.loginAsGuest();
    await _goHome();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox.expand(
            child: Stack(
              children: [
                const Positioned.fill(child: SoftBackgroundBubbles()),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColorScheme.surface,
                          borderRadius: BorderRadius.circular(AppRadius.hero),
                          boxShadow: AppShadows.card,
                          border: Border.all(color: AppColorScheme.border),
                        ),
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // ===== Logo =====
                            Container(
                              width: 82,
                              height: 82,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: AppGradientScheme.primary,
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: AppShadows.card,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.92),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    _logoAssetPath,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) {
                                      return const Icon(
                                        Icons.school_outlined,
                                        color: AppColorScheme.brandPrimary,
                                        size: 34,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),

                            // ===== Tabs (Login / Register) =====
                            Container(
                              decoration: BoxDecoration(
                                color: AppColorScheme.surfaceMuted,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: AppColorScheme.border,
                                ),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                children: [
                                  _TabPill(
                                    label: 'تسجيل دخول',
                                    selected: _tabIndex == 0,
                                    onTap: () => setState(() => _tabIndex = 0),
                                  ),
                                  _TabPill(
                                    label: 'إنشاء حساب',
                                    selected: _tabIndex == 1,
                                    onTap: () => setState(() => _tabIndex = 1),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: AppSpacing.lg),

                            // ===== Body =====
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              child: _tabIndex == 0
                                  ? _LoginForm(
                                      key: const ValueKey('login'),
                                      formKey: _loginFormKey,
                                      username: _username,
                                      password: _loginPass,
                                      obscure: _loginObscure,
                                      onToggleObscure: () => setState(
                                        () => _loginObscure = !_loginObscure,
                                      ),
                                      onSubmit: _login,
                                    )
                                  : _RegisterForm(
                                      key: const ValueKey('register'),
                                      formKey: _registerFormKey,
                                      name: _regName,
                                      email: _regEmail,
                                      password: _regPass,
                                      obscure: _regObscure,
                                      onToggleObscure: () => setState(
                                        () => _regObscure = !_regObscure,
                                      ),
                                      onSubmit: _register,
                                    ),
                            ),

                            const SizedBox(height: AppSpacing.md),

                            // ===== Guest Button =====
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: _guest,
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.button,
                                    ),
                                  ),
                                  side: const BorderSide(
                                    color: AppColorScheme.border,
                                  ),
                                  foregroundColor: AppColorScheme.textPrimary,
                                ),
                                child: const Text('تسجيل الدخول كضيف'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColorScheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            boxShadow: selected ? AppShadows.card : null,
          ),
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w800,
              color: selected
                  ? AppColorScheme.textPrimary
                  : AppColorScheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController username;
  final TextEditingController password;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;

  const _LoginForm({
    super.key,
    required this.formKey,
    required this.username,
    required this.password,
    required this.obscure,
    required this.onToggleObscure,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text('تسجيل الدخول', style: AppTextStyles.h1),
          ),
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'ادخل اسم المستخدم وكلمة المرور',
              style: AppTextStyles.bodyMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          TextFormField(
            controller: username,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(hintText: 'اسم المستخدم'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'اكتب اسم المستخدم' : null,
          ),
          const SizedBox(height: AppSpacing.md),

          TextFormField(
            controller: password,
            obscureText: obscure,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'كلمة المرور',
              suffixIcon: IconButton(
                onPressed: onToggleObscure,
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColorScheme.textSecondary,
                ),
              ),
            ),
            validator: (v) =>
                (v == null || v.isEmpty) ? 'اكتب كلمة المرور' : null,
          ),
          const SizedBox(height: AppSpacing.lg),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSubmit,
              child: const Text('تسجيل'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController password;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;

  const _RegisterForm({
    super.key,
    required this.formKey,
    required this.name,
    required this.email,
    required this.password,
    required this.obscure,
    required this.onToggleObscure,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text('إنشاء حساب', style: AppTextStyles.h1),
          ),
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'اكتب بياناتك لإنشاء حساب جديد',
              style: AppTextStyles.bodyMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          TextFormField(
            controller: name,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(hintText: 'اسمك'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'اكتب اسمك' : null,
          ),
          const SizedBox(height: AppSpacing.md),

          TextFormField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(hintText: 'الإيميل'),
            validator: (v) {
              final s = (v ?? '').trim();
              if (s.isEmpty) return 'اكتب الإيميل';
              if (!s.contains('@')) return 'اكتب إيميل صحيح';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),

          TextFormField(
            controller: password,
            obscureText: obscure,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'كلمة المرور',
              suffixIcon: IconButton(
                onPressed: onToggleObscure,
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColorScheme.textSecondary,
                ),
              ),
            ),
            validator: (v) =>
                (v == null || v.isEmpty) ? 'اكتب كلمة المرور' : null,
          ),
          const SizedBox(height: AppSpacing.lg),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSubmit,
              child: const Text('إنشاء حساب'),
            ),
          ),
        ],
      ),
    );
  }
}
