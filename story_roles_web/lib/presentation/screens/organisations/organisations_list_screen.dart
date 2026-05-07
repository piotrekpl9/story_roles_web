import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_roles_web/domain/entities/company.dart';
import 'package:story_roles_web/presentation/screens/organisations/bloc/organisations_list_bloc.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_typography.dart';

class OrganisationsListScreen extends StatefulWidget {
  const OrganisationsListScreen({super.key});

  @override
  State<OrganisationsListScreen> createState() =>
      _OrganisationsListScreenState();
}

class _OrganisationsListScreenState extends State<OrganisationsListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganisationsListBloc, OrganisationsListState>(
      builder: (context, state) {
        if (state.status == OrganisationsListStatus.loading ||
            state.status == OrganisationsListStatus.initial) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF8A5B)),
          );
        }

        if (state.status == OrganisationsListStatus.failure) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Failed to load organisations.',
                  style: TextStyle(color: Colors.white54),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context
                      .read<OrganisationsListBloc>()
                      .add(LoadOrganisationsListEvent()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final companies = state.filteredCompanies;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 16),
              child: Row(
                children: [
                  Text(
                    'Organisations',
                    style: AppTypography.titleLarge.copyWith(fontSize: 26),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 260,
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (v) => context
                          .read<OrganisationsListBloc>()
                          .add(SearchOrganisationsListEvent(v)),
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                          color: AppColors.onBackground.withValues(alpha: 0.4),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.onBackground.withValues(alpha: 0.5),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  context
                                      .read<OrganisationsListBloc>()
                                      .add(const SearchOrganisationsListEvent(''));
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.08),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<bool?>(
                      value: state.activeFilter,
                      dropdownColor: AppColors.card,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      hint: Text(
                        'All',
                        style: TextStyle(
                          color: AppColors.onBackground.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: null, child: Text('All')),
                        DropdownMenuItem(value: true, child: Text('Active')),
                        DropdownMenuItem(value: false, child: Text('Inactive')),
                      ],
                      onChanged: (v) => context
                          .read<OrganisationsListBloc>()
                          .add(FilterOrganisationsListEvent(v)),
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 1, color: AppColors.divider),
            Expanded(
              child: companies.isEmpty
                  ? const Center(
                      child: Text(
                        'No organisations found.',
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
                      itemCount: companies.length,
                      separatorBuilder: (_, __) =>
                          Container(height: 1, color: AppColors.divider),
                      itemBuilder: (ctx, i) =>
                          _CompanyTile(company: companies[i]),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _CompanyTile extends StatelessWidget {
  final Company company;

  const _CompanyTile({required this.company});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(Icons.business_outlined, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              company.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              '${company.allowedUsers} slots',
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ),
          SizedBox(
            width: 90,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: company.active
                    ? Colors.green.withValues(alpha: 0.15)
                    : Colors.red.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                company.active ? 'Active' : 'Inactive',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: company.active ? Colors.green : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
