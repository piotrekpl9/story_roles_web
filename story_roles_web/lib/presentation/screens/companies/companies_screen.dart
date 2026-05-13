import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:story_roles_web/domain/entities/company.dart';
import 'package:story_roles_web/presentation/screens/companies/bloc/companies_bloc.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_typography.dart';

class CompaniesScreen extends StatefulWidget {
  const CompaniesScreen({super.key});

  @override
  State<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateDialog(BuildContext context) {
    final nameController = TextEditingController();
    String? validationError;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.card,
              title: const Text(
                'New Company',
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Company name',
                      labelStyle:
                          TextStyle(color: AppColors.onBackground.withValues(alpha: 0.6)),
                      errorText: validationError,
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.06),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (_) {
                      if (validationError != null) {
                        setDialogState(() => validationError = null);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                BlocListener<CompaniesBloc, CompaniesState>(
                  listenWhen: (prev, curr) =>
                      curr.actionError != null &&
                      prev.actionError != curr.actionError,
                  listener: (_, state) {
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.actionError!)),
                    );
                  },
                  child: FilledButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      if (name.isEmpty) {
                        setDialogState(
                            () => validationError = 'Name cannot be empty.');
                        return;
                      }
                      context.read<CompaniesBloc>().add(CreateCompanyEvent(name));
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('Create'),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Company company) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: const Text(
            'Delete company',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Delete company "${company.name}"? This cannot be undone.',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                context.read<CompaniesBloc>().add(DeleteCompanyEvent(company.id));
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CompaniesBloc, CompaniesState>(
      listenWhen: (prev, curr) =>
          curr.actionError != null && prev.actionError != curr.actionError,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.actionError!)),
        );
      },
      child: BlocBuilder<CompaniesBloc, CompaniesState>(
        builder: (context, state) {
          if (state.status == CompaniesStatus.loading ||
              state.status == CompaniesStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF8A5B)),
            );
          }

          if (state.status == CompaniesStatus.failure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Failed to load companies.',
                    style: TextStyle(color: Colors.white54),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () =>
                        context.read<CompaniesBloc>().add(LoadCompaniesEvent()),
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
                      'Companies',
                      style: AppTypography.titleLarge.copyWith(fontSize: 26),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 260,
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        onChanged: (v) => context
                            .read<CompaniesBloc>()
                            .add(SearchCompaniesEvent(v)),
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
                                        .read<CompaniesBloc>()
                                        .add(const SearchCompaniesEvent(''));
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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                        hint: Text(
                          'All',
                          style: TextStyle(
                            color:
                                AppColors.onBackground.withValues(alpha: 0.6),
                            fontSize: 14,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: null, child: Text('All')),
                          DropdownMenuItem(value: true, child: Text('Active')),
                          DropdownMenuItem(
                              value: false, child: Text('Inactive')),
                        ],
                        onChanged: (v) => context
                            .read<CompaniesBloc>()
                            .add(FilterCompaniesEvent(v)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    FilledButton.icon(
                      onPressed: () => _showCreateDialog(context),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('New Company'),
                    ),
                  ],
                ),
              ),
              Container(height: 1, color: AppColors.divider),
              Expanded(
                child: companies.isEmpty
                    ? const Center(
                        child: Text(
                          'No companies found.',
                          style:
                              TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
                        itemCount: companies.length,
                        separatorBuilder: (_, __) =>
                            Container(height: 1, color: AppColors.divider),
                        itemBuilder: (ctx, i) => _CompanyTile(
                          company: companies[i],
                          onDelete: () =>
                              _showDeleteDialog(context, companies[i]),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CompanyTile extends StatelessWidget {
  final Company company;
  final VoidCallback onDelete;

  const _CompanyTile({required this.company, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/companies/${company.id}'),
      child: Padding(
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
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              color: Colors.white38,
              hoverColor: Colors.red.withValues(alpha: 0.12),
              tooltip: 'Delete company',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
