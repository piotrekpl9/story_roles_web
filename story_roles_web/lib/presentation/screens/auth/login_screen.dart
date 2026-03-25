import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:story_roles_web/presentation/screens/auth/bloc/auth_bloc.dart';
import 'package:story_roles_web/presentation/screens/auth/widgets/generic_input.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_typography.dart';
import 'package:story_roles_web/presentation/utils/app_config/consts.dart';
import 'package:story_roles_web/presentation/utils/l10n/app_localizations.dart';
import 'package:story_roles_web/presentation/widgets/button_primary.dart';
import 'package:story_roles_web/presentation/widgets/button_secondary.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            LoginClicked(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  String? _validateEmail(String? v) {
    if (v == null || v.isEmpty) return AppLocalizations.of(context)!.emailRequired;
    if (!v.contains('@')) return AppLocalizations.of(context)!.enterValidEmail;
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return AppLocalizations.of(context)!.passwordRequired;
    if (v.length < PresentationConsts.forms.minPasswordLength) {
      return AppLocalizations.of(context)!
          .passwordRequireMinCharacters(PresentationConsts.forms.minPasswordLength);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status &&
          (curr.status == AuthStatus.unauthenticated ||
              curr.status == AuthStatus.authenticated),
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.loginFailed),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.appName,
                      textAlign: TextAlign.center,
                      style: AppTypography.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.onBackground.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 32),
                    GenericInput(
                      controller: _emailController,
                      label: AppLocalizations.of(context)!.email,
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 16),
                    GenericInput(
                      controller: _passwordController,
                      label: AppLocalizations.of(context)!.password,
                      obscureText: true,
                      validator: _validatePassword,
                      onFieldSubmitted: (_) => _handleLogin(),
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final isLoading = state.status == AuthStatus.loading;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (isLoading)
                              const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFFF8A5B),
                                ),
                              )
                            else
                              ButtonPrimary(
                                onPressed: _handleLogin,
                                label: AppLocalizations.of(context)!.login,
                              ),
                            const SizedBox(height: 12),
                            ButtonSecondary(
                              onPressed: isLoading
                                  ? null
                                  : () => context.go('/register'),
                              label: AppLocalizations.of(context)!.register,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
