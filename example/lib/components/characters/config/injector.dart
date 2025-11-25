import 'package:dragonfly/dragonfly.dart';

// Import the generated config
part 'injector.config.dart';

/// Initialize all dependencies for the characters component
///
/// Call this function at app startup to register all
/// @Repository and @UseCaseComponent annotated classes with DragonflyContainer
Future<void> configureCharactersDependencies() async {
  final container = DragonflyContainer();
  // The extension method configureDependencies() is defined in injector.config.dart
  await container.configureDependencies();
}
