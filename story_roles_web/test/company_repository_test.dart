import 'package:flutter_test/flutter_test.dart';
import 'package:story_roles_web/data/datasources/mock/mock_company_web_api.dart';
import 'package:story_roles_web/data/repositories/company_repository_impl.dart';
import 'package:story_roles_web/domain/entities/company.dart';
import 'package:story_roles_web/domain/entities/user_summary.dart';

void main() {
  group('CompanyRepository.getAvailableUsers', () {
    late CompanyRepositoryImpl repository;

    setUp(() {
      repository = CompanyRepositoryImpl(companyWebApi: MockCompanyWebApi());
    });

    test('returns a non-empty list of UserSummary', () async {
      final result = await repository.getAvailableUsers();

      expect(result, isNotEmpty);
      expect(result, everyElement(isA<UserSummary>()));
    });

    test('maps id and email correctly', () async {
      final result = await repository.getAvailableUsers();

      expect(result.first.id, 1);
      expect(result.first.email, 'anna.kowalska@helion.pl');
    });


  });

  group('CompanyRepository.create', () {
    late CompanyRepositoryImpl repository;

    setUp(() {
      repository = CompanyRepositoryImpl(companyWebApi: MockCompanyWebApi());
    });

    test('returns a Company with the given name', () async {
      final result = await repository.create(name: 'New Publisher');

      expect(result, isA<Company>());
      expect(result.name, 'New Publisher');
    });

    test('returned company has a valid id', () async {
      final result = await repository.create(name: 'Test Co');

      expect(result.id, isPositive);
    });

    test('successive creates produce distinct ids', () async {
      final a = await repository.create(name: 'Alpha');
      final b = await repository.create(name: 'Beta');

      expect(a.id, isNot(equals(b.id)));
    });
  });

  group('CompanyRepository.delete', () {
    late CompanyRepositoryImpl repository;

    setUp(() {
      repository = CompanyRepositoryImpl(companyWebApi: MockCompanyWebApi());
    });

    test('removes the company with the given id', () async {
      final before = await repository.getAll();
      final targetId = before.first.id;

      await repository.delete(targetId);

      final after = await repository.getAll();
      expect(after.any((c) => c.id == targetId), isFalse);
    });

    test('deleting a non-existent id does not throw', () async {
      await expectLater(repository.delete(99999), completes);
    });
  });

  group('CompanyRepository.assignUser', () {
    late CompanyRepositoryImpl repository;

    setUp(() {
      repository = CompanyRepositoryImpl(companyWebApi: MockCompanyWebApi());
    });

    test('completes without throwing for valid ids', () async {
      await expectLater(repository.assignUser(1, 2), completes);
    });
  });
}
