import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:story_roles_web/domain/entities/company.dart';
import 'package:story_roles_web/domain/repositories/company_repository.dart';

enum CompaniesStatus { initial, loading, success, failure }

abstract class CompaniesEvent extends Equatable {
  const CompaniesEvent();

  @override
  List<Object?> get props => [];
}

class LoadCompaniesEvent extends CompaniesEvent {}

class SearchCompaniesEvent extends CompaniesEvent {
  final String query;

  const SearchCompaniesEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterCompaniesEvent extends CompaniesEvent {
  final bool? activeFilter;

  const FilterCompaniesEvent(this.activeFilter);

  @override
  List<Object?> get props => [activeFilter];
}

class CreateCompanyEvent extends CompaniesEvent {
  final String name;

  const CreateCompanyEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class DeleteCompanyEvent extends CompaniesEvent {
  final int id;

  const DeleteCompanyEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CompaniesState extends Equatable {
  final CompaniesStatus status;
  final List<Company> allCompanies;
  final String searchQuery;
  final bool? activeFilter;
  final String? actionError;

  const CompaniesState({
    this.status = CompaniesStatus.initial,
    this.allCompanies = const [],
    this.searchQuery = '',
    this.activeFilter,
    this.actionError,
  });

  List<Company> get filteredCompanies {
    return allCompanies.where((company) {
      final matchesSearch =
          company.name.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesFilter =
          activeFilter == null || company.active == activeFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  CompaniesState copyWith({
    CompaniesStatus? status,
    List<Company>? allCompanies,
    String? searchQuery,
    bool? Function()? activeFilterProvider,
    String? Function()? actionErrorProvider,
  }) {
    return CompaniesState(
      status: status ?? this.status,
      allCompanies: allCompanies ?? this.allCompanies,
      searchQuery: searchQuery ?? this.searchQuery,
      activeFilter:
          activeFilterProvider != null ? activeFilterProvider() : activeFilter,
      actionError:
          actionErrorProvider != null ? actionErrorProvider() : actionError,
    );
  }

  @override
  List<Object?> get props =>
      [status, allCompanies, searchQuery, activeFilter, actionError];
}

class CompaniesBloc extends Bloc<CompaniesEvent, CompaniesState> {
  final CompanyRepository _companyRepository;

  CompaniesBloc({required CompanyRepository companyRepository})
      : _companyRepository = companyRepository,
        super(const CompaniesState()) {
    on<LoadCompaniesEvent>(_onLoad);
    on<SearchCompaniesEvent>(_onSearch);
    on<FilterCompaniesEvent>(_onFilter);
    on<CreateCompanyEvent>(_onCreate);
    on<DeleteCompanyEvent>(_onDelete);
  }

  Future<void> _onLoad(
    LoadCompaniesEvent event,
    Emitter<CompaniesState> emit,
  ) async {
    emit(state.copyWith(status: CompaniesStatus.loading));
    try {
      final companies = await _companyRepository.getAll();
      emit(state.copyWith(
        status: CompaniesStatus.success,
        allCompanies: companies,
      ));
    } catch (e, st) {
      debugPrint('CompaniesBloc error: $e\n$st');
      emit(state.copyWith(status: CompaniesStatus.failure));
    }
  }

  void _onSearch(
    SearchCompaniesEvent event,
    Emitter<CompaniesState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onFilter(
    FilterCompaniesEvent event,
    Emitter<CompaniesState> emit,
  ) {
    emit(state.copyWith(activeFilterProvider: () => event.activeFilter));
  }

  Future<void> _onCreate(
    CreateCompanyEvent event,
    Emitter<CompaniesState> emit,
  ) async {
    try {
      final company = await _companyRepository.create(name: event.name);
      emit(state.copyWith(
        allCompanies: [...state.allCompanies, company],
        actionErrorProvider: () => null,
      ));
    } catch (e, st) {
      debugPrint('CompaniesBloc create error: $e\n$st');
      emit(state.copyWith(actionErrorProvider: () => 'Failed to create company.'));
    }
  }

  Future<void> _onDelete(
    DeleteCompanyEvent event,
    Emitter<CompaniesState> emit,
  ) async {
    try {
      await _companyRepository.delete(event.id);
      emit(state.copyWith(
        allCompanies: state.allCompanies.where((c) => c.id != event.id).toList(),
        actionErrorProvider: () => null,
      ));
    } catch (e, st) {
      debugPrint('CompaniesBloc delete error: $e\n$st');
      emit(state.copyWith(actionErrorProvider: () => 'Failed to delete company.'));
    }
  }
}
