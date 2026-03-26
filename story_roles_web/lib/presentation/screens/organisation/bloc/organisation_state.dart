part of 'organisation_bloc.dart';

enum OrganisationStatus { initial, loading, success, failure }

class OrganisationState extends Equatable {
  final OrganisationStatus status;
  final Company? company;
  final List<User> users;

  const OrganisationState({
    this.status = OrganisationStatus.initial,
    this.company,
    this.users = const [],
  });

  OrganisationState copyWith({
    OrganisationStatus? status,
    Company? company,
    List<User>? users,
  }) {
    return OrganisationState(
      status: status ?? this.status,
      company: company ?? this.company,
      users: users ?? this.users,
    );
  }

  @override
  List<Object?> get props => [status, company, users];
}
