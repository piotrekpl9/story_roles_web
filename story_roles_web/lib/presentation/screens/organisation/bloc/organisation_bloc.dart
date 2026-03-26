import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:story_roles_web/domain/entities/company.dart';
import 'package:story_roles_web/domain/entities/user.dart';
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

  Future<void> _onLoad(
    LoadOrganisationEvent event,
    Emitter<OrganisationState> emit,
  ) async {
    emit(state.copyWith(status: OrganisationStatus.loading));
    try {
      final results = await Future.wait([
        _companyRepository.getCompany(),
        _companyRepository.getUsers(),
      ]);
      emit(state.copyWith(
        status: OrganisationStatus.success,
        company: results[0] as Company,
        users: results[1] as List<User>,
      ));
    } catch (e, st) {
      debugPrint('OrganisationBloc error: $e\n$st');
      emit(state.copyWith(status: OrganisationStatus.failure));
    }
  }
}
