import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:story_roles_web/core/consts.dart';
import 'package:story_roles_web/data/core/token_interceptor.dart';
import 'package:story_roles_web/data/datasources/abstractions/auth_web_api.dart';
import 'package:story_roles_web/data/datasources/abstractions/chapter_web_api.dart';
import 'package:story_roles_web/data/datasources/abstractions/company_web_api.dart';
import 'package:story_roles_web/data/datasources/abstractions/lector_voice_web_api.dart';
import 'package:story_roles_web/data/datasources/abstractions/project_web_api.dart';
import 'package:story_roles_web/data/datasources/abstractions/storage_data_source.dart';
import 'package:story_roles_web/data/datasources/abstractions/track_upload_web_api.dart';
import 'package:story_roles_web/data/datasources/abstractions/track_web_api.dart';
import 'package:story_roles_web/data/datasources/auth_web_api_impl.dart';
import 'package:story_roles_web/data/datasources/chapter_web_api_impl.dart';
import 'package:story_roles_web/data/datasources/company_web_api_impl.dart';
import 'package:story_roles_web/data/datasources/lector_voice_web_api_impl.dart';
import 'package:story_roles_web/data/datasources/mock/mock_auth_web_api.dart';
import 'package:story_roles_web/data/datasources/mock/mock_chapter_web_api.dart';
import 'package:story_roles_web/data/datasources/mock/mock_company_web_api.dart';
import 'package:story_roles_web/data/datasources/mock/mock_lector_voice_web_api.dart';
import 'package:story_roles_web/data/datasources/mock/mock_project_web_api.dart';
import 'package:story_roles_web/data/datasources/mock/mock_track_upload_web_api.dart';
import 'package:story_roles_web/data/datasources/mock/mock_track_web_api.dart';
import 'package:story_roles_web/data/datasources/project_web_api_impl.dart';
import 'package:story_roles_web/data/datasources/storage_data_source_impl.dart';
import 'package:story_roles_web/data/datasources/track_upload_web_api_impl.dart';
import 'package:story_roles_web/data/datasources/track_web_api_impl.dart';
import 'package:story_roles_web/data/repositories/auth_repository_impl.dart';
import 'package:story_roles_web/data/repositories/chapter_repository_impl.dart';
import 'package:story_roles_web/data/repositories/company_repository_impl.dart';
import 'package:story_roles_web/data/repositories/lector_voice_repository_impl.dart';
import 'package:story_roles_web/data/repositories/project_repository_impl.dart';
import 'package:story_roles_web/data/repositories/track_repository_impl.dart';
import 'package:story_roles_web/data/usecases/auth/login.dart';
import 'package:story_roles_web/data/usecases/auth/logout.dart';
import 'package:story_roles_web/data/usecases/auth/register.dart';
import 'package:story_roles_web/data/usecases/track/upload_track.dart';
import 'package:story_roles_web/domain/repositories/auth_repository.dart';
import 'package:story_roles_web/domain/repositories/chapter_repository.dart';
import 'package:story_roles_web/domain/repositories/company_repository.dart';
import 'package:story_roles_web/domain/repositories/lector_voice_repository.dart';
import 'package:story_roles_web/domain/repositories/project_repository.dart';
import 'package:story_roles_web/domain/repositories/track_repository.dart';
import 'package:story_roles_web/presentation/screens/auth/bloc/auth_bloc.dart';

const _useMocks = false;

class Injector {
  static final Injector _instance = Injector._();

  GetIt get _getIt => GetIt.instance;

  Dio get dioInstance => GetIt.instance.get<Dio>();

  T resolve<T extends Object>() => _getIt.get<T>();

  factory Injector() => _instance;

  Injector._() {
    _getIt.registerLazySingleton<StorageDataSource>(
      () => StorageDataSourceImpl(),
    );
    _initDio();
    _initData();
    _initUseCases();
    _initBlocs();
  }

  void _initDio() {
    final dio = Dio();
    dio.options
      ..baseUrl = CoreConsts.baseUrl
      ..connectTimeout = const Duration(seconds: 30)
      ..followRedirects = true;
    dio.interceptors.add(TokenInterceptor(storageDataSource: _getIt()));
    _getIt.registerSingleton<Dio>(dio);
  }

  void _initUseCases() {
    _getIt.registerLazySingleton(() => Login(_getIt()));
    _getIt.registerLazySingleton(() => Register(_getIt()));
    _getIt.registerLazySingleton(() => Logout(_getIt()));
    _getIt.registerLazySingleton(() => UploadTrack(_getIt()));
  }

  void _initBlocs() {
    _getIt.registerFactory(
      () => AuthBloc(
        login: _getIt(),
        register: _getIt(),
        logout: _getIt(),
        storage: _getIt(),
      ),
    );
  }

  void _initData() {
    if (_useMocks) {
      _getIt.registerLazySingleton<AuthWebApi>(() => MockAuthWebApi());
      _getIt.registerLazySingleton<TrackWebApi>(() => MockTrackWebApi());
      _getIt.registerLazySingleton<TrackUploadWebApi>(
        () => MockTrackUploadWebApi(),
      );
      _getIt.registerLazySingleton<CompanyWebApi>(() => MockCompanyWebApi());
      _getIt.registerLazySingleton<ProjectWebApi>(() => MockProjectWebApi());
      _getIt.registerLazySingleton<ChapterWebApi>(
        () => MockChapterWebApi(
          trackWebApi: _getIt<TrackWebApi>() as MockTrackWebApi,
        ),
      );
      _getIt.registerLazySingleton<LectorVoiceWebApi>(
        () => MockLectorVoiceWebApi(),
      );
    } else {
      _getIt.registerLazySingleton<AuthWebApi>(
        () => AuthWebApiImpl(dio: _getIt()),
      );
      _getIt.registerLazySingleton<TrackWebApi>(
        () => TrackWebApiImpl(dio: _getIt()),
      );
      _getIt.registerLazySingleton<TrackUploadWebApi>(
        () => TrackUploadWebApiImpl(dio: _getIt()),
      );
      _getIt.registerLazySingleton<CompanyWebApi>(
        () => CompanyWebApiImpl(dio: _getIt()),
      );
      _getIt.registerLazySingleton<ProjectWebApi>(
        () => ProjectWebApiImpl(dio: _getIt()),
      );
      _getIt.registerLazySingleton<ChapterWebApi>(
        () => ChapterWebApiImpl(dio: _getIt()),
      );
      _getIt.registerLazySingleton<LectorVoiceWebApi>(
        () => LectorVoiceWebApiImpl(dio: _getIt()),
      );
    }

    _getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(webApi: _getIt(), storageDataSource: _getIt()),
    );
    _getIt.registerLazySingleton<TrackRepository>(
      () => TrackRepositoryImpl(
        trackWebApi: _getIt(),
        trackUploadWebApi: _getIt(),
      ),
    );
    _getIt.registerLazySingleton<CompanyRepository>(
      () => CompanyRepositoryImpl(companyWebApi: _getIt()),
    );
    _getIt.registerLazySingleton<ProjectRepository>(
      () => ProjectRepositoryImpl(projectWebApi: _getIt()),
    );
    _getIt.registerLazySingleton<ChapterRepository>(
      () => ChapterRepositoryImpl(chapterWebApi: _getIt()),
    );
    _getIt.registerLazySingleton<LectorVoiceRepository>(
      () => LectorVoiceRepositoryImpl(webApi: _getIt()),
    );
  }
}
