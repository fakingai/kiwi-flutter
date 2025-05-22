// 核心功能 - 依赖注入 (Dependency Injection)
// 配置和管理应用中的依赖关系。
// 使用 get_it 库来实现服务定位或依赖注入。

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:kiwi/app/viewmodels/chat_viewmodel.dart';
import 'package:kiwi/app/viewmodels/project_viewmodel.dart';
import 'package:kiwi/app/viewmodels/session_viewmodel.dart';
import 'package:kiwi/data/datasources/local/auth_local_datasource.dart';
import 'package:kiwi/data/datasources/local/auth_local_datasource_impl.dart';
import 'package:kiwi/data/datasources/local/cos_credentials_local_datasource.dart';
import 'package:kiwi/data/datasources/remote/message_remote_datasource.dart';
import 'package:kiwi/data/datasources/remote/project_remote_datasource.dart';
import 'package:kiwi/data/repositories/message_repository_impl.dart';
import 'package:kiwi/data/repositories/project_repository_impl.dart';
import 'package:kiwi/domain/repositories/message_repository.dart';
import 'package:kiwi/domain/repositories/project_repository.dart';
import 'package:kiwi/domain/usecases/create_project_usecase.dart';
import 'package:kiwi/domain/usecases/create_session_usecase.dart';
import 'package:kiwi/domain/usecases/get_messages_usecase.dart';
import 'package:kiwi/domain/usecases/get_projects_usecase.dart';
import 'package:kiwi/domain/usecases/get_sessions_usecase.dart';
import 'package:kiwi/domain/usecases/send_message_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kiwi/core/network/error_interceptor.dart';
import '../network/auth_interceptor.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/remote/auth_remote_datasource_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/get_auth_user_info_usecase.dart'; // Import the new use case
import '../../app/viewmodels/auth_viewmodel.dart';
import '../../app/viewmodels/main_viewmodel.dart'; // Import MainViewModel
import '../constants/api_constants.dart';
import '../network/logging_interceptor.dart';
import 'package:kiwi/core/network/api_client.dart';
import 'package:kiwi/app/usecases/get_file_list_usecase.dart';
import 'package:kiwi/data/datasources/remote/file_remote_datasource.dart';
import 'package:kiwi/data/repositories/file_repository_impl.dart';
import 'package:kiwi/domain/repositories/file_repository.dart';
import 'package:kiwi/app/viewmodels/file_viewmodel.dart';
import 'package:kiwi/data/datasources/remote/cos_direct_datasource.dart';

/// 全局依赖注入容器实例
final GetIt sl = GetIt.instance;

/// 初始化依赖注入
Future<void> setupDependencies() async {
  // Dio instance
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.BASE_URL,
        // You can add other default options here, like connectTimeout, receiveTimeout
      ),
    );
    dio.interceptors.add(LoggingInterceptor()); // Add the logging interceptor
    dio.interceptors.add(ErrorInterceptor()); // Add the error interceptor
    dio.interceptors.add(AuthInterceptor()); // Add the auth interceptor
    return dio;
  });

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // 外部依赖
  sl.registerLazySingleton(() => http.Client());

  // 数据源
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<ProjectRemoteDataSource>(
    () => ProjectRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<ApiClient>(() => ApiClientImpl());
  sl.registerLazySingleton<FileRemoteDataSource>(
    () => FileRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // COS 相关依赖
  sl.registerLazySingleton<CosCredentialsLocalDataSource>(
    () => CosCredentialsLocalDataSourceImpl(
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );
  sl.registerLazySingleton<CosDirectDatasource>(
    () => CosDirectDatasource(dio: sl<Dio>()),
  );
  // FileRepository 依赖注入，传入 COS 数据源
  sl.registerLazySingleton<FileRepository>(
    () => FileRepositoryImpl(
      sl<FileRemoteDataSource>(),
      sl<CosDirectDatasource>(),
      sl<CosCredentialsLocalDataSource>(),
    ),
  );

  // 仓库
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
    ),
  );
  sl.registerLazySingleton<ProjectRepository>(
    () =>
        ProjectRepositoryImpl(remoteDataSource: sl<ProjectRemoteDataSource>()),
  );

  // Message
  sl.registerLazySingleton<MessageRemoteDataSource>(
    () => MessageRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<MessageRepository>(
    () =>
        MessageRepositoryImpl(remoteDataSource: sl<MessageRemoteDataSource>()),
  );
  sl.registerLazySingleton<SendMessageUseCase>(
    () => SendMessageUseCase(sl<MessageRepository>()),
  );
  sl.registerLazySingleton<CreateSessionUseCase>(
    () => CreateSessionUseCase(sl<MessageRepository>()),
  );
  sl.registerLazySingleton<GetSessionsUseCase>(
    () => GetSessionsUseCase(sl<MessageRepository>()),
  );
  sl.registerLazySingleton<GetMessagesUseCase>(
    () => GetMessagesUseCase(sl<MessageRepository>()),
  );

  // 用例
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetAuthUserInfoUseCase>(
    () => GetAuthUserInfoUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetProjectsUseCase>(
    () => GetProjectsUseCase(sl<ProjectRepository>()),
  );
  sl.registerLazySingleton<CreateProjectUseCase>(
    () => CreateProjectUseCase(sl<ProjectRepository>()),
  );
  sl.registerLazySingleton<GetFileListUseCase>(
    () => GetFileListUseCase(sl<FileRepository>()),
  );

  // ViewModel
  sl.registerFactory<AuthViewModel>(
    () => AuthViewModel(
      loginUseCase: sl<LoginUseCase>(),
      registerUseCase: sl<RegisterUseCase>(),
      localDataSource: sl<AuthLocalDataSource>(),
    ),
  );
  sl.registerFactory<MainViewModel>(
    () => MainViewModel(getAuthUserInfoUseCase: sl<GetAuthUserInfoUseCase>()),
  );
  sl.registerFactory<ProjectViewModel>(
    () => ProjectViewModel(
      getProjectsUseCase: sl<GetProjectsUseCase>(),
      createProjectUseCase: sl<CreateProjectUseCase>(),
    ),
  );
  sl.registerFactory<FileViewModel>(() => FileViewModel(sl<FileRepository>()));
  sl.registerFactory<ChatViewModel>(
    () => ChatViewModel(
      sendMessageUseCase: sl<SendMessageUseCase>(),
      getMessagesUseCase: sl<GetMessagesUseCase>(),
    ),
  );
  sl.registerFactory<SessionViewModel>(
    () => SessionViewModel(getSessionsUseCase: sl<GetSessionsUseCase>()),
  );
}
