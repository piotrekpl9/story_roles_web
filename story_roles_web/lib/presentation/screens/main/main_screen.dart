import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_roles_web/core/injector.dart';
import 'package:story_roles_web/domain/repositories/project_repository.dart';
import 'package:story_roles_web/presentation/player/persistent_player_bar.dart';
import 'package:story_roles_web/presentation/player/bloc/player_bloc.dart';
import 'package:story_roles_web/presentation/player/bloc/player_bloc_state.dart';
import 'package:story_roles_web/presentation/screens/home/bloc/home_bloc.dart';
import 'package:story_roles_web/presentation/screens/home/home_view.dart';
import 'package:story_roles_web/domain/repositories/company_repository.dart';
import 'package:story_roles_web/presentation/screens/company/bloc/company_bloc.dart';
import 'package:story_roles_web/presentation/screens/company/company_screen.dart';
import 'package:story_roles_web/presentation/screens/profile/profile_screen.dart';
import 'package:story_roles_web/presentation/screens/script/script_view.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';
import 'package:story_roles_web/presentation/widgets/sidebar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // ── Sidebar ──────────────────────────────────────────
                Sidebar(
                  selectedIndex: _selectedIndex,
                  onSelect: (i) => setState(() => _selectedIndex = i),
                ),
                Container(width: 1, color: AppColors.divider),

                // ── Content ──────────────────────────────────────────
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: [
                      // Home – project list
                      BlocProvider(
                        create: (_) => HomeBloc(
                          projectRepository: Injector().resolve<ProjectRepository>(),
                        )..add(LoadHomeEvent()),
                        child: const HomeView(),
                      ),

                      // Company
                      BlocProvider(
                        create: (_) => CompanyBloc(
                          companyRepository: Injector().resolve<CompanyRepository>(),
                        )..add(const LoadCompanyEvent(0)),
                        child: const CompanyScreen(),
                      ),

                      // Profile
                      const ProfileScreen(),
                    ],
                  ),
                ),

                // ── Script panel (right) ──────────────────────────────
                BlocBuilder<PlayerBloc, PlayerBlocState>(
                  builder: (context, state) {
                    return AnimatedSize(
                      duration: Duration.zero,
                      child: state.hasTrack
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(width: 1, color: AppColors.divider),
                                Container(
                                  width: 300,
                                  color: AppColors.sidebar,
                                  child: const ScriptView(),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    );
                  },
                ),
              ],
            ),
          ),

          // ── Persistent Player Bar ─────────────────────────────────
          const PersistentPlayerBar(),
        ],
      ),
    );
  }
}
