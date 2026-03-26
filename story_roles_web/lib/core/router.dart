import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:story_roles_web/core/injector.dart';
import 'package:story_roles_web/domain/entities/project.dart';
import 'package:story_roles_web/domain/repositories/chapter_repository.dart';
import 'package:story_roles_web/domain/repositories/project_repository.dart';
import 'package:story_roles_web/domain/repositories/track_repository.dart';
import 'package:story_roles_web/presentation/screens/auth/bloc/auth_bloc.dart';
import 'package:story_roles_web/presentation/screens/auth/login_screen.dart';
import 'package:story_roles_web/presentation/screens/auth/register_screen.dart';
import 'package:story_roles_web/presentation/screens/home/bloc/home_bloc.dart';
import 'package:story_roles_web/presentation/screens/home/home_view.dart';
import 'package:story_roles_web/presentation/screens/main/main_shell.dart';
import 'package:story_roles_web/presentation/screens/profile/profile_screen.dart';
import 'package:story_roles_web/presentation/screens/project/bloc/project_bloc.dart';
import 'package:story_roles_web/presentation/screens/project/project_screen.dart';
import 'package:story_roles_web/domain/repositories/company_repository.dart';
import 'package:story_roles_web/presentation/screens/organisation/bloc/organisation_bloc.dart';
import 'package:story_roles_web/presentation/screens/organisation/organisation_screen.dart';

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
                  create: (_) => HomeBloc(
                    projectRepository: Injector().resolve<ProjectRepository>(),
                  )..add(LoadHomeEvent()),
                  child: const HomeView(),
                ),
              ),
              routes: [
                GoRoute(
                  path: 'projects/:id',
                  pageBuilder: (context, state) {
                    final project = state.extra as Project;
                    return NoTransitionPage(
                      child: BlocProvider(
                        create: (_) => ProjectBloc(
                          chapterRepository:
                              Injector().resolve<ChapterRepository>(),
                          trackRepository:
                              Injector().resolve<TrackRepository>(),
                        )..add(LoadProjectEvent(project.id)),
                        child: ProjectScreen(project: project),
                      ),
                    );
                  },
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/organisation',
              pageBuilder: (context, state) => NoTransitionPage(
                child: BlocProvider(
                  create: (_) => OrganisationBloc(
                    companyRepository: Injector().resolve<CompanyRepository>(),
                  )..add(const LoadOrganisationEvent()),
                  child: const OrganisationScreen(),
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
