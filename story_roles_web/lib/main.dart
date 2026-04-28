import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:story_roles_web/core/injector.dart';
import 'package:go_router/go_router.dart';
import 'package:story_roles_web/core/router.dart';
import 'package:story_roles_web/domain/repositories/track_repository.dart';
import 'package:story_roles_web/presentation/player/bloc/player_bloc.dart';
import 'package:story_roles_web/presentation/screens/auth/bloc/auth_bloc.dart';
import 'package:story_roles_web/presentation/utils/l10n/app_localizations.dart';

void main() {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  Injector();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthBloc _authBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = Injector().resolve<AuthBloc>()..add(AppStarted());
    _router = buildRouter(_authBloc);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider(
          create: (_) => PlayerBloc(
            dio: Injector().dioInstance,
            storageDataSource: Injector().resolve(),
            trackRepository: Injector().resolve<TrackRepository>(),
          ),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
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
      ),
    );
  }
}
