import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:dragonfly_builder/builder/models/dependency_config.dart';
import 'package:dragonfly_builder/builder/models/importable_type.dart';
import 'package:dragonfly_builder/builder/models/injected_dependency.dart';
import 'package:dragonfly_builder/builder/models/injectable_type.dart';
import 'package:source_gen/source_gen.dart';

/// Visitor that collects all injectable dependencies from a library
class InjectableVisitor extends SimpleElementVisitor<void> {
  final List<DependencyConfig> dependencies = [];
  final BuildStep buildStep;

  InjectableVisitor(this.buildStep);

  @override
  void visitClassElement(ClassElement element) {
    // Check for @Injectable, @Singleton, @LazySingleton annotations
    final injectableChecker = TypeChecker.fromUrl(
        'package:dragonfly_annotations/dragonfly_annotations.dart#Injectable');
    final singletonChecker = TypeChecker.fromUrl(
        'package:dragonfly_annotations/dragonfly_annotations.dart#Singleton');
    final lazySingletonChecker = TypeChecker.fromUrl(
        'package:dragonfly_annotations/dragonfly_annotations.dart#LazySingleton');
    final repositoryChecker = TypeChecker.fromUrl(
        'package:dragonfly_annotations/dragonfly_annotations.dart#Repository');
    final useCaseChecker = TypeChecker.fromUrl(
        'package:dragonfly_annotations/dragonfly_annotations.dart#UseCaseComponent');

    ConstantReader? annotation;
    int injectableType = InjectableType.factory;

    if (singletonChecker.hasAnnotationOfExact(element)) {
      annotation =
          ConstantReader(singletonChecker.firstAnnotationOfExact(element));
      injectableType = InjectableType.singleton;
    } else if (lazySingletonChecker.hasAnnotationOfExact(element)) {
      annotation =
          ConstantReader(lazySingletonChecker.firstAnnotationOfExact(element));
      injectableType = InjectableType.lazySingleton;
    } else if (injectableChecker.hasAnnotationOfExact(element)) {
      annotation =
          ConstantReader(injectableChecker.firstAnnotationOfExact(element));
      injectableType = InjectableType.factory;
    } else if (repositoryChecker.hasAnnotationOfExact(element)) {
      annotation =
          ConstantReader(repositoryChecker.firstAnnotationOfExact(element));
      injectableType = InjectableType
          .lazySingleton; // Repositories are lazy singletons by default
    } else if (useCaseChecker.hasAnnotationOfExact(element)) {
      annotation =
          ConstantReader(useCaseChecker.firstAnnotationOfExact(element));
      injectableType =
          InjectableType.factory; // Use cases are factories by default
    }

    if (annotation == null) return;

    // Extract annotation data
    final asType = annotation.peek('as')?.typeValue;
    final envList = annotation.peek('env')?.listValue;
    final scope = annotation.peek('scope')?.stringValue;
    final order = annotation.peek('order')?.intValue ?? 0;

    // Get environments
    final environments = envList
            ?.map((e) => e.toStringValue() ?? '')
            .where((e) => e.isNotEmpty)
            .toList() ??
        [];

    // Get constructor parameters (dependencies)
    if (element.constructors.isEmpty) return;

    final constructor = element.constructors.firstWhere(
      (c) => c.name.isEmpty || c.name == element.name,
      orElse: () => element.constructors.first,
    );

    final dependencies = constructor.parameters.map((param) {
      return InjectedDependency(
        type: ImportableType(
          name: param.type.getDisplayString(withNullability: false),
          import: param.type.element?.librarySource?.uri.toString(),
        ),
        paramName: param.name,
        isPositional: param.isPositional,
      );
    }).toList();

    // Create dependency config
    final typeImpl = ImportableType(
      name: element.name,
      import: element.librarySource.uri.toString(),
    );

    final type = asType != null
        ? ImportableType(
            name: asType.getDisplayString(withNullability: false),
            import: asType.element?.librarySource?.uri.toString(),
          )
        : typeImpl;

    final config = DependencyConfig(
      type: type,
      typeImpl: typeImpl,
      injectableType: injectableType,
      dependencies: dependencies,
      environments: environments,
      scope: scope,
      orderPosition: order,
    );

    this.dependencies.add(config);
  }
}
