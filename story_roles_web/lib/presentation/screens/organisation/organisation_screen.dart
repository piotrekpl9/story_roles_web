import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_roles_web/core/utils/date_helper.dart';
import 'package:story_roles_web/presentation/screens/organisation/bloc/organisation_bloc.dart';
import 'package:story_roles_web/presentation/screens/organisation/widgets/stat_chip.dart';
import 'package:story_roles_web/presentation/screens/organisation/widgets/user_row.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_typography.dart';

class OrganisationScreen extends StatelessWidget {
  const OrganisationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganisationBloc, OrganisationState>(
      builder: (context, state) {
        if (state.status == OrganisationStatus.loading ||
            state.status == OrganisationStatus.initial) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF8A5B)),
          );
        }
        if (state.status == OrganisationStatus.failure) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Failed to load organisation data.',
                  style: TextStyle(color: Colors.white54),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed:
                      () => context.read<OrganisationBloc>().add(
                        const LoadOrganisationEvent(),
                      ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final company = state.company!;
        final activeUsers = state.users.where((u) => u.active).length;

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Organisation',
                      style: AppTypography.titleLarge.copyWith(fontSize: 28),
                    ),
                    const SizedBox(height: 20),

                    // Company card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.business_outlined,
                                  color: AppColors.primary,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    company.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Created ${formatDate(company.createdAt)}',
                                    style: TextStyle(
                                      color: AppColors.onBackground.withValues(
                                        alpha: 0.45,
                                      ),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      company.active
                                          ? Colors.green.withValues(alpha: 0.12)
                                          : Colors.red.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  company.active ? 'Active' : 'Inactive',
                                  style: TextStyle(
                                    color:
                                        company.active
                                            ? Colors.green
                                            : Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(height: 1, color: AppColors.divider),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              StatChip(
                                icon: Icons.people_outline,
                                label: 'Users',
                                value: '$activeUsers / ${company.allowedUsers}',
                              ),
                              const SizedBox(width: 24),
                              StatChip(
                                icon: Icons.folder_outlined,
                                label: 'Account limit',
                                value: '${company.allowedUsers}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                    Text(
                      'Members',
                      style: AppTypography.titleLarge.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Container(height: 1, color: AppColors.divider),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
              sliver: SliverList.separated(
                separatorBuilder:
                    (_, _) => Container(height: 1, color: AppColors.divider),
                itemCount: state.users.length,
                itemBuilder: (ctx, i) => UserRow(user: state.users[i]),
              ),
            ),
          ],
        );
      },
    );
  }
}
