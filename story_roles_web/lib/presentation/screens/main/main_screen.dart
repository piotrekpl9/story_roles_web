import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_roles_web/core/injector.dart';
import 'package:story_roles_web/presentation/player/persistent_player_bar.dart';
import 'package:story_roles_web/presentation/player/player_manager.dart';
import 'package:story_roles_web/presentation/screens/home/bloc/home_bloc.dart';
import 'package:story_roles_web/presentation/screens/home/home_view.dart';
import 'package:story_roles_web/presentation/screens/profile/profile_screen.dart';
import 'package:story_roles_web/presentation/screens/track_upload/bloc/track_upload_bloc.dart';
import 'package:story_roles_web/presentation/screens/track_upload/track_upload_view.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_typography.dart';

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
                _Sidebar(
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
                              context.read<PlayerManager>().playTrack(track),
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

// ─── Sidebar ────────────────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _Sidebar({required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: AppColors.sidebar,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
            child: Text(
              'StoryRoles',
              style: AppTypography.titleLarge.copyWith(fontSize: 22),
            ),
          ),
          _SidebarItem(
            icon: Icons.home_rounded,
            label: 'Home',
            isSelected: selectedIndex == 0,
            onTap: () => onSelect(0),
          ),
          _SidebarItem(
            icon: Icons.add_circle_outline_rounded,
            label: 'Upload',
            isSelected: selectedIndex == 1,
            onTap: () => onSelect(1),
          ),
          _SidebarItem(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            isSelected: selectedIndex == 2,
            onTap: () => onSelect(2),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: active
                ? AppColors.primary.withValues(alpha: 0.15)
                : _hovered
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: active ? AppColors.primary : AppColors.onBackground,
                size: 22,
              ),
              const SizedBox(width: 14),
              Text(
                widget.label,
                style: TextStyle(
                  color: active ? AppColors.primary : AppColors.onBackground,
                  fontSize: 15,
                  fontWeight:
                      active ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
