import 'package:get_it/get_it.dart';
import 'package:todo_list/features/data/data_provider/hive_box_provider.dart';
import 'package:todo_list/features/data/datasources/task_hive_data_sources.dart';
import 'package:todo_list/features/data/repositories/todo_repository_impl.dart';
import 'package:todo_list/features/domain/repository/todo_repository.dart';
import 'package:todo_list/features/presentation/bloc/todo_bloc/todo_cubit.dart';
import 'package:todo_list/screen_factory.dart';
import 'package:todo_list/ui/navigation/app_navigation_impl.dart';
import 'package:todo_list/ui/theme/app_theme.dart';

Future<void> init() async {
  final di = GetIt.instance;

  // Core
  di.registerLazySingleton<ScreenFactory>(
    () => const ScreenFactoryImpl(),
  );

  di.registerLazySingleton<AppNavigation>(
    () => AppNavigationImpl(screenFactory: di<ScreenFactory>()),
  );

  final appTheme = AppThemeImpl();
  await appTheme.init();

  di.registerLazySingleton<AppTheme>(
    () => appTheme,
  );

  //Blocs

  di.registerFactory(
    () => TodoCubit(
      todoRepository: di<TodoRepository>(),
    ),
  );

  // Repository

  di.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      taskHiveDataSources: di<TaskHiveDataSources>(),
    ),
  );

  // DataSources

  di.registerLazySingleton<TaskHiveDataSources>(
    () => TaskHiveDataSourcesImpl(
      hiveBoxProvider: di<HiveBoxProvider>(),
    ),
  );

  di.registerLazySingleton<HiveBoxProvider>(
    () => HiveBoxProviderImpl(),
  );
}
