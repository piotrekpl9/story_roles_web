part of 'organisation_bloc.dart';

sealed class OrganisationEvent extends Equatable {
  const OrganisationEvent();

  @override
  List<Object> get props => [];
}

class LoadOrganisationEvent extends OrganisationEvent {
  const LoadOrganisationEvent();
}
