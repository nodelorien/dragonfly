import 'package:dragonfly/framework/di/dragonfly_container.dart';
import 'package:dragonfly_annotations/dragonfly_annotations.dart';
import 'package:user/components/characters/config/injector.config.dart';

DragonflyContainer container = DragonflyContainer();

@DragonflyInjectableInit(
  initializerName: "init", // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
void configureDependencies() => container.init();
