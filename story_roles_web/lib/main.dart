import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_roles_web/core/injector.dart';
import 'package:story_roles_web/presentation/player/bloc/player_bloc.dart';
import 'package:story_roles_web/presentation/screens/auth/bloc/auth_bloc.dart';
import 'package:story_roles_web/presentation/screens/auth/login_screen.dart';
import 'package:story_roles_web/presentation/screens/main/main_screen.dart';
import 'package:story_roles_web/presentation/utils/l10n/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Injector();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayerBloc(
        dio: Injector().dioInstance,
        storageDataSource: Injector().resolve(),
      ),
      child: BlocProvider.value(
        value: Injector().resolve<AuthBloc>()..add(AppStarted()),
        child: BlocListener<AuthBloc, AuthState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            final nav = navigatorKey.currentState;
            if (nav == null) return;
            if (state.status == AuthStatus.unauthenticated) {
              nav.pushAndRemoveUntil(
                PageRouteBuilder(
                  pageBuilder: (ctx, a, b) => const LoginScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
                (route) => false,
              );
            } else if (state.status == AuthStatus.authenticated) {
              nav.pushAndRemoveUntil(
                PageRouteBuilder(
                  pageBuilder: (ctx, a, b) => const MainScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
                (route) => false,
              );
            }
          },
          child: MaterialApp(
            navigatorKey: navigatorKey,
            title: 'StoryRoles',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFFF8A5B),
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFF1C1C1C),
            ),
            home: const LoginScreen(),
          ),
        ),
      ),
    );
  }
}
