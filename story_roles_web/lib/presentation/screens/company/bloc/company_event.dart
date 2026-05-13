part of 'company_bloc.dart';

sealed class CompanyEvent extends Equatable {
  const CompanyEvent();

  @override
  List<Object> get props => [];
}

class LoadCompanyEvent extends CompanyEvent {
  final int companyId;
  const LoadCompanyEvent(this.companyId);

  @override
  List<Object> get props => [companyId];
}

class UpdateCompanyEvent extends CompanyEvent {
  final int id;
  final String name;

  const UpdateCompanyEvent({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];
}

class AssignUserEvent extends CompanyEvent {
  final int companyId;
  final int userId;

  const AssignUserEvent({required this.companyId, required this.userId});

  @override
  List<Object> get props => [companyId, userId];
}
