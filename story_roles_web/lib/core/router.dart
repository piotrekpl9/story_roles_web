import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:story_roles_web/core/injector.dart';
import 'package:story_roles_web/domain/repositories/chapter_repository.dart';
import 'package:story_roles_web/domain/repositories/company_repository.dart';
import 'package:story_roles_web/domain/repositories/lector_voice_repository.dart';
import 'package:story_roles_web/domain/repositories/project_repository.dart';
import 'package:story_roles_web/domain/repositories/track_repository.dart';
import 'package:story_roles_web/presentation/screens/auth/bloc/auth_bloc.dart';
import 'package:story_roles_web/presentation/screens/auth/login_screen.dart';
import 'package:story_roles_web/presentation/screens/auth/register_screen.dart';
import 'package:story_roles_web/presentation/screens/companies/bloc/companies_bloc.dart';
import 'package:story_roles_web/presentation/screens/companies/companies_screen.dart';
import 'package:story_roles_web/presentation/screens/company/bloc/company_bloc.dart';
import 'package:story_roles_web/presentation/screens/company/company_screen.dart';
import 'package:story_roles_web/presentation/screens/projects/bloc/projects_bloc.dart';
import 'package:story_roles_web/presentation/screens/projects/projects_view.dart';
import 'package:story_roles_web/presentation/screens/main/main_shell.dart';
import 'package:story_roles_web/presentation/screens/profile/profile_screen.dart';
import 'package:story_roles_web/presentation/screens/project/bloc/project_bloc.dart';
import 'package:story_roles_web/presentation/screens/project/project_screen.dart';

GoRouter buildRouter(AuthBloc authBloc, {GlobalKey<NavigatorState>? navigatorKey}) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/projects',
    redirect: (context, state) {
      final status = authBloc.state.status;
      final isAuth = status == AuthStatus.authenticated;
      final isOnAuth = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isAuth && !isOnAuth) return '/login';
      if (isAuth && isOnAuth) return '/projects';

      if (isAuth &&
          !authBloc.state.isAdmin &&
          state.matchedLocation.startsWith('/companies')) {
        return '/projects';
      }

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
              path: '/projects',
              pageBuilder: (context, state) => NoTransitionPage(
                child: BlocProvider(
                  create: (_) => ProjectsBloc(
                    projectRepository: Injector().resolve<ProjectRepository>(),
                  )..add(LoadProjectsEvent()),
                  child: const ProjectsView(),
                ),
              ),
              routes: [
                GoRoute(
                  path: ':id',
                  pageBuilder: (context, state) {
                    final projectId = int.parse(state.pathParameters['id']!);
                    final lectorVoiceRepo =
                        Injector().resolve<LectorVoiceRepository>();
                    return NoTransitionPage(
                      child: RepositoryProvider<LectorVoiceRepository>.value(
                        value: lectorVoiceRepo,
                        child: BlocProvider(
                          create: (_) => ProjectBloc(
                            projectRepository:
                                Injector().resolve<ProjectRepository>(),
                            chapterRepository:
                                Injector().resolve<ChapterRepository>(),
                            trackRepository:
                                Injector().resolve<TrackRepository>(),
                            lectorVoiceRepository: lectorVoiceRepo,
                          )..add(LoadProjectEvent(projectId)),
                          child: const ProjectScreen(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/companies',
              pageBuilder: (context, state) => NoTransitionPage(
                child: BlocProvider(
                  create: (_) => CompaniesBloc(
                    companyRepository: Injector().resolve<CompanyRepository>(),
                  )..add(LoadCompaniesEvent()),
                  child: const CompaniesScreen(),
                ),
              ),
              routes: [
                GoRoute(
                  path: ':id',
                  pageBuilder: (context, state) {
                    final companyId = int.parse(state.pathParameters['id']!);
                    return NoTransitionPage(
                      child: BlocProvider(
                        create: (_) => CompanyBloc(
                          companyRepository:
                              Injector().resolve<CompanyRepository>(),
                        )..add(LoadCompanyEvent(companyId)),
                        child: const CompanyScreen(),
                      ),
                    );
                  },
                ),
              ],
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
