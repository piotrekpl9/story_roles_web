# Tasks

## Completed
- TASK-001: add getAll() to company repository layer ✓

## Current task
- **ID**: TASK-002
- **Status**: READY
- **Files**: lib/presentation/screens/organisations/bloc/organisations_list_bloc.dart

### AC
- [ ] `OrganisationsListBloc` loads list of companies via `CompanyRepository.getAll()`
- [ ] State has: status (initial/loading/success/failure), companies list, search query, optional active filter
- [ ] Filtering by search query and active status works in-memory

### Prompt for Gemma
You are a Flutter developer. Create a BLoC for an organisations list screen. Output the file. FILE: path then ```dart code``` format. No explanations.

CONTEXT — Company entity:
```dart
class Company {
  final int id;
  final String name;
  final int allowedUsers;
  final bool active;
  final DateTime createdAt;
}
```

CONTEXT — CompanyRepository interface:
```dart
abstract class CompanyRepository {
  Future<Company> getCompany();
  Future<List<User>> getUsers();
  Future<List<Company>> getAll();
}
```

CONTEXT — existing OrganisationBloc pattern (for reference):
```dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:story_roles_web/domain/entities/company.dart';
import 'package:story_roles_web/domain/repositories/company_repository.dart';

part 'organisation_event.dart';
part 'organisation_state.dart';

class OrganisationBloc extends Bloc<OrganisationEvent, OrganisationState> {
  final CompanyRepository _companyRepository;
  OrganisationBloc({required CompanyRepository companyRepository})
      : _companyRepository = companyRepository,
        super(const OrganisationState()) {
    on<LoadOrganisationEvent>(_onLoad);
  }
  Future<void> _onLoad(LoadOrganisationEvent event, Emitter<OrganisationState> emit) async {
    emit(state.copyWith(status: OrganisationStatus.loading));
    try {
      final results = await Future.wait([_companyRepository.getCompany(), _companyRepository.getUsers()]);
      emit(state.copyWith(status: OrganisationStatus.success, company: results[0] as Company, users: results[1] as List<User>));
    } catch (e, st) {
      debugPrint('OrganisationBloc error: $e\n$st');
      emit(state.copyWith(status: OrganisationStatus.failure));
    }
  }
}
```

CREATE FILE: lib/presentation/screens/organisations/bloc/organisations_list_bloc.dart

It should be a SINGLE FILE (no parts) containing:
1. Enum `OrganisationsListStatus { initial, loading, success, failure }`
2. Events: `LoadOrganisationsListEvent`, `SearchOrganisationsListEvent(String query)`, `FilterOrganisationsListEvent(bool? activeFilter)` — all extend `Equatable`
3. State `OrganisationsListState extends Equatable` with fields: status, allCompanies (full list), searchQuery (String, default ''), activeFilter (bool?, nullable), and computed getter `filteredCompanies` that filters allCompanies by searchQuery (case-insensitive name match) and activeFilter
4. `OrganisationsListBloc` with handlers for all 3 events. Load calls `companyRepository.getAll()`. Search and filter just update state fields (no async). Use `package:story_roles_web` imports.
