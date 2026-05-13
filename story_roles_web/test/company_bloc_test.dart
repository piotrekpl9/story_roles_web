import 'package:flutter_test/flutter_test.dart';
import 'package:story_roles_web/data/datasources/mock/mock_company_web_api.dart';
import 'package:story_roles_web/data/repositories/company_repository_impl.dart';
import 'package:story_roles_web/presentation/screens/company/bloc/company_bloc.dart';

CompanyBloc _makeBloc() => CompanyBloc(
      companyRepository: CompanyRepositoryImpl(
        companyWebApi: MockCompanyWebApi(),
      ),
    );

void main() {
  group('CompanyBloc — AssignUserEvent', () {
    test('success: users list reloads in state', () async {
      final bloc = _makeBloc();
      bloc.add(const LoadCompanyEvent());
      await Future.delayed(const Duration(milliseconds: 300));

      final before = bloc.state.users.length;

      bloc.add(const AssignUserEvent(companyId: 1, userId: 10));
      await Future.delayed(const Duration(milliseconds: 400));

      expect(bloc.state.status, CompanyStatus.success);
      expect(bloc.state.users.length, before);
      expect(bloc.state.actionError, isNull);

      bloc.close();
    });

    test('success: status remains success after assign', () async {
      final bloc = _makeBloc();
      bloc.add(const LoadCompanyEvent());
      await Future.delayed(const Duration(milliseconds: 300));

      bloc.add(const AssignUserEvent(companyId: 1, userId: 10));
      await Future.delayed(const Duration(milliseconds: 400));

      expect(bloc.state.status, CompanyStatus.success);

      bloc.close();
    });

    test('failure: actionError is set when repository throws', () async {
      final bloc = CompanyBloc(
        companyRepository: CompanyRepositoryImpl(
          companyWebApi: _FailingAssignUserApi(),
        ),
      );
      bloc.add(const LoadCompanyEvent());
      await Future.delayed(const Duration(milliseconds: 300));

      bloc.add(const AssignUserEvent(companyId: 1, userId: 99));
      await Future.delayed(const Duration(milliseconds: 400));

      expect(bloc.state.actionError, isNotNull);

      bloc.close();
    });
  });
}

class _FailingAssignUserApi extends MockCompanyWebApi {
  @override
  Future<void> assignUser(int companyId, int userId) async {
    throw Exception('assign failed');
  }
}
