import 'package:get_it/get_it.dart';

typedef DiItemType<T> = Map<String, T>;

enum DragonflyInjectorType { singleton, factory }

class DragonflyContainer {
  static void set<T extends Object>(String name, T dependency,
      {DragonflyInjectorType type = DragonflyInjectorType.singleton}) {
    if (type == DragonflyInjectorType.singleton) {
      if (!GetIt.I.isRegistered<T>(instanceName: name)) {
        GetIt.I.registerSingleton<T>(dependency, instanceName: name);
      }
    }
  }

  static T get<T extends Object>(String name) {
    return GetIt.I.get<T>(instanceName: name);
  }
}
