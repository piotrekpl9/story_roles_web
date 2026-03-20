import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_roles_web/presentation/screens/auth/bloc/auth_bloc.dart';
import 'package:story_roles_web/presentation/screens/auth/widgets/generic_input.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_typography.dart';
import 'package:story_roles_web/presentation/utils/app_config/consts.dart';
import 'package:story_roles_web/presentation/utils/l10n/app_localizations.dart';
import 'package:story_roles_web/presentation/widgets/button_primary.dart';
import 'package:story_roles_web/presentation/widgets/button_secondary.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            RegisterClicked(
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
          (curr.status == AuthStatus.registered ||
              (curr.status == AuthStatus.unauthenticated &&
                  curr.errorMessage != null)),
      listener: (context, state) {
        if (state.status == AuthStatus.registered) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.registrationSuccess),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.registrationFailed),
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
                      'Create your account',
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
                      onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                    ),
                    const SizedBox(height: 16),
                    GenericInput(
                      controller: _passwordController,
                      label: AppLocalizations.of(context)!.password,
                      obscureText: true,
                      validator: _validatePassword,
                      focusNode: _passwordFocusNode,
                      onFieldSubmitted: (_) => _handleRegister(),
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
                                onPressed: _handleRegister,
                                label:
                                    AppLocalizations.of(context)!.register,
                              ),
                            const SizedBox(height: 12),
                            ButtonSecondary(
                              onPressed: isLoading
                                  ? null
                                  : () => Navigator.of(context).pop(),
                              label: AppLocalizations.of(context)!.backToLogin,
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
