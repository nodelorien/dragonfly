import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:dragonfly_annotations/annotations/injectable/injectable_annotations.dart';
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
    final injectableAnnotation = TypeChecker.fromRuntime(InjectableUseCase);
    if (!injectableAnnotation.hasAnnotationOfExact(element)) return;
    ConstantReader? annotation =
        ConstantReader(injectableAnnotation.firstAnnotationOfExact(element));
    int injectableType = InjectableType.factory;
    if (injectableAnnotation.firstAnnotationOfExact(element) == null) return;

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

    if (element.constructors.isEmpty) return;

    try {
      final constructors = element.constructors.toList();
      final constructor = constructors.first;

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
      print("==========>>>>>>>> dependencies: ${this.dependencies}");
    } catch (e, s) {
      print("==========>>>>>>>> error: $e, $s");
    }
  }
}
