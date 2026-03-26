import 'package:flutter/material.dart';
import 'package:story_roles_web/domain/entities/user.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';

class UserRow extends StatelessWidget {
  final User user;

  const UserRow({super.key, required this.user});

  String _roleLabel(UserRole role) => switch (role) {
    UserRole.admin => 'Admin',
    UserRole.owner => 'Owner',
    UserRole.member => 'Member',
  };

  Color _roleColor(UserRole role) => switch (role) {
    UserRole.admin => Colors.purpleAccent,
    UserRole.owner => const Color(0xFFFF8A5B),
    UserRole.member => Colors.blueAccent,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            child: Text(
              user.username.isNotEmpty ? user.username[0].toUpperCase() : '?',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.email,
                  style: TextStyle(
                    color: AppColors.onBackground.withValues(alpha: 0.45),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: _roleColor(user.role).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _roleLabel(user.role),
              style: TextStyle(
                color: _roleColor(user.role),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color:
                  user.active
                      ? Colors.green
                      : Colors.red.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
