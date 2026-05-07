import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:story_roles_web/domain/entities/company.dart';
import 'package:story_roles_web/domain/repositories/company_repository.dart';

enum OrganisationsListStatus { initial, loading, success, failure }

abstract class OrganisationsListEvent extends Equatable {
  const OrganisationsListEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrganisationsListEvent extends OrganisationsListEvent {}

class SearchOrganisationsListEvent extends OrganisationsListEvent {
  final String query;

  const SearchOrganisationsListEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterOrganisationsListEvent extends OrganisationsListEvent {
  final bool? activeFilter;

  const FilterOrganisationsListEvent(this.activeFilter);

  @override
  List<Object?> get props => [activeFilter];
}

class OrganisationsListState extends Equatable {
  final OrganisationsListStatus status;
  final List<Company> allCompanies;
  final String searchQuery;
  final bool? activeFilter;

  const OrganisationsListState({
    this.status = OrganisationsListStatus.initial,
    this.allCompanies = const [],
    this.searchQuery = '',
    this.activeFilter,
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

  OrganisationsListState copyWith({
    OrganisationsListStatus? status,
    List<Company>? allCompanies,
    String? searchQuery,
    bool? Function()? activeFilterProvider,
  }) {
    return OrganisationsListState(
      status: status ?? this.status,
      allCompanies: allCompanies ?? this.allCompanies,
      searchQuery: searchQuery ?? this.searchQuery,
      activeFilter:
          activeFilterProvider != null ? activeFilterProvider() : activeFilter,
    );
  }

  @override
  List<Object?> get props => [status, allCompanies, searchQuery, activeFilter];
}

class OrganisationsListBloc
    extends Bloc<OrganisationsListEvent, OrganisationsListState> {
  final CompanyRepository _companyRepository;

  OrganisationsListBloc({required CompanyRepository companyRepository})
      : _companyRepository = companyRepository,
        super(const OrganisationsListState()) {
    on<LoadOrganisationsListEvent>(_onLoad);
    on<SearchOrganisationsListEvent>(_onSearch);
    on<FilterOrganisationsListEvent>(_onFilter);
  }

  Future<void> _onLoad(
    LoadOrganisationsListEvent event,
    Emitter<OrganisationsListState> emit,
  ) async {
    emit(state.copyWith(status: OrganisationsListStatus.loading));
    try {
      final companies = await _companyRepository.getAll();
      emit(state.copyWith(
        status: OrganisationsListStatus.success,
        allCompanies: companies,
      ));
    } catch (e, st) {
      debugPrint('OrganisationsListBloc error: $e\n$st');
      emit(state.copyWith(status: OrganisationsListStatus.failure));
    }
  }

  void _onSearch(
    SearchOrganisationsListEvent event,
    Emitter<OrganisationsListState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onFilter(
    FilterOrganisationsListEvent event,
    Emitter<OrganisationsListState> emit,
  ) {
    emit(state.copyWith(activeFilterProvider: () => event.activeFilter));
  }
}
