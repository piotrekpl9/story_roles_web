import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_roles_web/core/injector.dart';
import 'package:story_roles_web/presentation/player/persistent_player_bar.dart';
import 'package:story_roles_web/presentation/player/bloc/player_bloc.dart';
import 'package:story_roles_web/presentation/player/bloc/player_event.dart';
import 'package:story_roles_web/presentation/screens/home/bloc/home_bloc.dart';
import 'package:story_roles_web/presentation/screens/home/home_view.dart';
import 'package:story_roles_web/presentation/screens/profile/profile_screen.dart';
import 'package:story_roles_web/presentation/screens/track_upload/bloc/track_upload_bloc.dart';
import 'package:story_roles_web/presentation/screens/track_upload/track_upload_view.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';
import 'package:story_roles_web/presentation/widgets/sidebar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  HomeBloc? _homeBloc;

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
                      // Home
                      BlocProvider(
                        create: (ctx) {
                          _homeBloc = HomeBloc(
                            trackRepository: Injector().resolve(),
                          )..add(LoadHomeEvent());
                          return _homeBloc!;
                        },
                        child: HomeView(
                          onTrackSelected: (track) =>
                              context.read<PlayerBloc>().add(PlayTrackEvent(track)),
                        ),
                      ),

                      // Upload
                      BlocProvider(
                        create: (_) => TrackUploadBloc(
                          uploadTrack: Injector().resolve(),
                        ),
                        child: TrackUploadView(
                          onUploadSuccess: () {
                            setState(() => _selectedIndex = 0);
                            _homeBloc?.add(RefreshTracksAfterUpload());
                          },
                        ),
                      ),

                      // Profile
                      const ProfileScreen(),
                    ],
                  ),
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
