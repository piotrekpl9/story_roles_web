import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:story_roles_web/core/injector.dart';
import 'package:story_roles_web/presentation/player/bloc/player_bloc.dart';
import 'package:story_roles_web/presentation/player/bloc/player_event.dart';
import 'package:story_roles_web/presentation/screens/auth/bloc/auth_bloc.dart';
import 'package:story_roles_web/presentation/screens/auth/login_screen.dart';
import 'package:story_roles_web/presentation/screens/auth/register_screen.dart';
import 'package:story_roles_web/presentation/screens/home/bloc/home_bloc.dart';
import 'package:story_roles_web/presentation/screens/home/home_view.dart';
import 'package:story_roles_web/presentation/screens/main/main_shell.dart';
import 'package:story_roles_web/presentation/screens/profile/profile_screen.dart';
import 'package:story_roles_web/presentation/screens/track_upload/bloc/track_upload_bloc.dart';
import 'package:story_roles_web/presentation/screens/track_upload/track_upload_view.dart';

GoRouter buildRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final status = authBloc.state.status;
      final isAuth = status == AuthStatus.authenticated;
      final isOnAuth = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isAuth && !isOnAuth) return '/login';
      if (isAuth && isOnAuth) return '/home';
      return null;
    },
    refreshListenable: _AuthStatusListenable(authBloc),
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (ctx, s) => const NoTransitionPage(child: LoginScreen()),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (ctx, s) =>
            const NoTransitionPage(child: RegisterScreen()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) => NoTransitionPage(
                child: BlocProvider(
                  create: (ctx) => HomeBloc(
                    trackRepository: Injector().resolve(),
                  )..add(LoadHomeEvent()),
                  child: HomeView(
                    onTrackSelected: (track) =>
                        context.read<PlayerBloc>().add(PlayTrackEvent(track)),
                  ),
                ),
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/upload',
              pageBuilder: (context, state) => NoTransitionPage(
                child: BlocProvider(
                  create: (_) => TrackUploadBloc(
                    uploadTrack: Injector().resolve(),
                  ),
                  child: TrackUploadView(
                    onUploadSuccess: () => context.go('/home'),
                  ),
                ),
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/profile',
              pageBuilder: (ctx, s) =>
                  const NoTransitionPage(child: ProfileScreen()),
            ),
          ]),
        ],
      ),
    ],
  );
}

class _AuthStatusListenable extends ChangeNotifier {
  _AuthStatusListenable(AuthBloc authBloc) {
    _sub = authBloc.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
