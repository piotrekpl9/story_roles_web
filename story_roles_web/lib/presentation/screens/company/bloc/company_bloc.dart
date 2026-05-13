import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:story_roles_web/domain/entities/company.dart';
import 'package:story_roles_web/domain/entities/user.dart';
import 'package:story_roles_web/domain/repositories/company_repository.dart';

part 'company_event.dart';
part 'company_state.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final CompanyRepository repository;

  CompanyBloc({required CompanyRepository companyRepository})
      : repository = companyRepository,
        super(const CompanyState()) {
    on<LoadCompanyEvent>(_onLoad);
    on<UpdateCompanyEvent>(_onUpdate);
    on<AssignUserEvent>(_onAssignUser);
  }

  Future<void> _onUpdate(
    UpdateCompanyEvent event,
    Emitter<CompanyState> emit,
  ) async {
    try {
      await repository.update(event.id, name: event.name);
      final updated = Company(
        id: state.company!.id,
        name: event.name,
        allowedUsers: state.company!.allowedUsers,
        active: state.company!.active,
        createdAt: state.company!.createdAt,
      );
      emit(state.copyWith(
        company: updated,
        actionErrorProvider: () => null,
      ));
    } catch (e, st) {
      debugPrint('CompanyBloc update error: $e\n$st');
      emit(state.copyWith(actionErrorProvider: () => 'Failed to update company.'));
    }
  }

  Future<void> _onAssignUser(
    AssignUserEvent event,
    Emitter<CompanyState> emit,
  ) async {
    try {
      await repository.assignUser(event.companyId, event.userId);
      final users = await repository.getUsersByCompany(event.companyId);
      emit(state.copyWith(
        users: users,
        actionErrorProvider: () => null,
      ));
    } catch (e, st) {
      debugPrint('CompanyBloc assignUser error: $e\n$st');
      emit(state.copyWith(actionErrorProvider: () => 'Failed to assign user.'));
    }
  }

  Future<void> _onLoad(
    LoadCompanyEvent event,
    Emitter<CompanyState> emit,
  ) async {
    emit(state.copyWith(status: CompanyStatus.loading, companyId: event.companyId));
    try {
      final results = await Future.wait([
        repository.getById(event.companyId),
        repository.getUsersByCompany(event.companyId),
      ]);
      emit(state.copyWith(
        status: CompanyStatus.success,
        company: results[0] as Company,
        users: results[1] as List<User>,
      ));
    } catch (e, st) {
      debugPrint('CompanyBloc error: $e\n$st');
      emit(state.copyWith(status: CompanyStatus.failure));
    }
  }
}
