import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_roles_web/presentation/player/persistent_player_bar.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';
import 'package:story_roles_web/presentation/widgets/sidebar.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell shell;

  const MainShell({super.key, required this.shell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Sidebar(
                  selectedIndex: shell.currentIndex,
                  onSelect: (i) => shell.goBranch(
                    i,
                    initialLocation: i == shell.currentIndex,
                  ),
                ),
                Container(width: 1, color: AppColors.divider),
                Expanded(child: shell),
              ],
            ),
          ),
          const PersistentPlayerBar(),
        ],
      ),
    );
  }
}

