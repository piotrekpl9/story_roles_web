import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_roles_web/core/utils/date_helper.dart';
import 'package:story_roles_web/domain/entities/user_summary.dart';
import 'package:story_roles_web/domain/repositories/company_repository.dart';

import 'package:story_roles_web/presentation/screens/company/bloc/company_bloc.dart';
import 'package:story_roles_web/presentation/screens/company/widgets/stat_chip.dart';
import 'package:story_roles_web/presentation/screens/company/widgets/user_row.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_typography.dart';

class CompanyScreen extends StatelessWidget {
  const CompanyScreen({super.key});

  void _showAssignUserDialog(BuildContext context, int companyId) {
    final repository = context.read<CompanyBloc>().repository;
    showDialog<bool>(
      context: context,
      builder: (dialogContext) =>
          _AssignUserDialog(companyId: companyId, repository: repository),
    ).then((assigned) {
      if ((assigned ?? false) && context.mounted) {
        context.read<CompanyBloc>().add(LoadCompanyEvent(companyId));
      }
    });
  }

  void _showEditDialog(BuildContext context, String currentName, int companyId) {
    final nameController = TextEditingController(text: currentName);
    String? validationError;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.card,
              title: const Text(
                'Edit Company',
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
                      labelStyle: TextStyle(
                        color: AppColors.onBackground.withValues(alpha: 0.6),
                      ),
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
                FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) {
                      setDialogState(
                          () => validationError = 'Name cannot be empty.');
                      return;
                    }
                    context.read<CompanyBloc>().add(
                          UpdateCompanyEvent(id: companyId, name: name),
                        );
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CompanyBloc, CompanyState>(
      listenWhen: (prev, curr) =>
          curr.actionError != null && prev.actionError != curr.actionError,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.actionError!)),
        );
      },
      child: BlocBuilder<CompanyBloc, CompanyState>(
        builder: (context, state) {
          if (state.status == CompanyStatus.loading ||
              state.status == CompanyStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF8A5B)),
            );
          }
          if (state.status == CompanyStatus.failure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Failed to load company data.',
                    style: TextStyle(color: Colors.white54),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.read<CompanyBloc>().add(
                          LoadCompanyEvent(state.companyId),
                        ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final company = state.company!;
          final activeUsers = state.users.length;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Company',
                        style: AppTypography.titleLarge.copyWith(fontSize: 28),
                      ),
                      const SizedBox(height: 20),
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
                                        color:
                                            AppColors.onBackground.withValues(
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
                                    color: company.active
                                        ? Colors.green.withValues(alpha: 0.12)
                                        : Colors.red.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    company.active ? 'Active' : 'Inactive',
                                    style: TextStyle(
                                      color: company.active
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined,
                                      size: 20),
                                  color: Colors.white54,
                                  hoverColor:
                                      AppColors.primary.withValues(alpha: 0.12),
                                  tooltip: 'Edit company',
                                  onPressed: () => _showEditDialog(
                                    context,
                                    company.name,
                                    company.id,
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
                      Row(
                        children: [
                          Text(
                            'Members',
                            style:
                                AppTypography.titleLarge.copyWith(fontSize: 16),
                          ),
                          const Spacer(),
                          FilledButton.icon(
                            icon: const Icon(Icons.person_add_outlined,
                                size: 16),
                            label: const Text('Assign User'),
                            onPressed: () => _showAssignUserDialog(
                              context,
                              company.id,
                            ),
                          ),
                        ],
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
                  separatorBuilder: (_, __) =>
                      Container(height: 1, color: AppColors.divider),
                  itemCount: state.users.length,
                  itemBuilder: (ctx, i) => UserRow(user: state.users[i]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AssignUserDialog extends StatefulWidget {
  final int companyId;
  final CompanyRepository repository;

  const _AssignUserDialog({
    required this.companyId,
    required this.repository,
  });

  @override
  State<_AssignUserDialog> createState() => _AssignUserDialogState();
}

class _AssignUserDialogState extends State<_AssignUserDialog> {
  late Future<List<UserSummary>> _usersFuture;
  final _searchController = TextEditingController();
  String _query = '';
  UserSummary? _selected;
  bool _assigning = false;
  String? _assignError;

  @override
  void initState() {
    super.initState();
    _usersFuture = widget.repository.getAvailableUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (_selected == null) return;
    setState(() {
      _assigning = true;
      _assignError = null;
    });
    try {
      await widget.repository.assignUser(widget.companyId, _selected!.id);
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) {
        setState(() {
          _assigning = false;
          _assignError = 'Failed to assign user. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.card,
      title: const Text('Assign User', style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: 400,
        child: FutureBuilder<List<UserSummary>>(
          future: _usersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 120,
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF8A5B)),
                ),
              );
            }
            if (snapshot.hasError) {
              return SizedBox(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Failed to load users.',
                        style: TextStyle(color: Colors.white54)),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => setState(() {
                        _usersFuture = widget.repository.getAvailableUsers();
                      }),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final all = snapshot.data ?? [];
            final filtered = _query.isEmpty
                ? all
                : all
                    .where((u) =>
                        u.email.toLowerCase().contains(_query.toLowerCase()))
                    .toList();

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Search by email',
                    labelStyle: TextStyle(
                        color: AppColors.onBackground.withValues(alpha: 0.6)),
                    prefixIcon:
                        Icon(Icons.search, color: AppColors.onBackground.withValues(alpha: 0.5)),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.06),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 240),
                  child: filtered.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text('No users found.',
                              style: TextStyle(color: Colors.white54)),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: filtered.length,
                          itemBuilder: (_, i) {
                            final user = filtered[i];
                            final isSelected = _selected?.id == user.id;
                            return ListTile(
                              dense: true,
                              leading: CircleAvatar(
                                radius: 16,
                                backgroundColor:
                                    AppColors.primary.withValues(alpha: 0.15),
                                child: Text(
                                  user.email[0].toUpperCase(),
                                  style: TextStyle(
                                      color: AppColors.primary, fontSize: 12),
                                ),
                              ),
                              title: Text(user.email,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13)),
                              selected: isSelected,
                              selectedTileColor:
                                  AppColors.primary.withValues(alpha: 0.12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              onTap: () => setState(() => _selected = user),
                            );
                          },
                        ),
                ),
                if (_assignError != null) ...[
                  const SizedBox(height: 8),
                  Text(_assignError!,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
                ],
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: _assigning ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: (_selected == null || _assigning) ? null : _confirm,
          child: _assigning
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Text('Assign'),
        ),
      ],
    );
  }
}
