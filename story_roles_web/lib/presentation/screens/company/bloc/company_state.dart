part of 'company_bloc.dart';

enum CompanyStatus { initial, loading, success, failure }

class CompanyState extends Equatable {
  final CompanyStatus status;
  final int companyId;
  final Company? company;
  final List<User> users;
  final String? actionError;

  const CompanyState({
    this.status = CompanyStatus.initial,
    this.companyId = 0,
    this.company,
    this.users = const [],
    this.actionError,
  });

  CompanyState copyWith({
    CompanyStatus? status,
    int? companyId,
    Company? company,
    List<User>? users,
    String? Function()? actionErrorProvider,
  }) {
    return CompanyState(
      status: status ?? this.status,
      companyId: companyId ?? this.companyId,
      company: company ?? this.company,
      users: users ?? this.users,
      actionError:
          actionErrorProvider != null ? actionErrorProvider() : actionError,
    );
  }

  @override
  List<Object?> get props => [status, companyId, company, users, actionError];
}
