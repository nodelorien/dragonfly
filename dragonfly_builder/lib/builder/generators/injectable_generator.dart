// lib/src/injector_generator.dart
import 'dart:async';
import 'dart:convert';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dragonfly_annotations/dragonfly_annotations.dart';
import 'package:dragonfly_builder/builder/models/dependency_config.dart';
import 'package:dragonfly_builder/builder/resolvers/Importable_type_resolver.dart';
import 'package:dragonfly_builder/builder/resolvers/dependency_resolver.dart';
import 'package:source_gen/source_gen.dart';

const TypeChecker _typeCheckerRepository = TypeChecker.fromRuntime(Repository);
const TypeChecker _typeCheckerUseCase = TypeChecker.fromRuntime(UseCase);

class InjectableGenerator implements Generator {
  RegExp? _classNameMatcher, _fileNameMatcher;
  late bool _autoRegister;

  InjectableGenerator(Map options) {
    _autoRegister = options['auto_register'] ?? false;
    if (_autoRegister) {
      if (options['class_name_pattern'] != null) {
        _classNameMatcher = RegExp(options['class_name_pattern']);
      }
      if (options['file_name_pattern'] != null) {
        _fileNameMatcher = RegExp(options['file_name_pattern']);
      }
    }
  }

  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) async {
    final allDepsInStep = <DependencyConfig>[];
    for (var clazz in library.classes) {
      if (_typeCheckerRepository.hasAnnotationOf(clazz) ||
          (_autoRegister && _hasConventionalMatch(clazz))) {
        allDepsInStep.add(DependencyResolver(
          const TypeChecker.fromRuntime(Repository),
          getResolver(await buildStep.resolver.libraries.toList()),
        ).resolve(clazz));
      }
      if (_typeCheckerUseCase.hasAnnotationOf(clazz) ||
          (_autoRegister && _hasConventionalMatch(clazz))) {
        allDepsInStep.add(DependencyResolver(
          const TypeChecker.fromRuntime(UseCase),
          getResolver(await buildStep.resolver.libraries.toList()),
        ).resolve(clazz));
      }
    }

    return allDepsInStep.isNotEmpty ? jsonEncode(allDepsInStep) : null;
  }

  ImportableTypeResolver getResolver(List<LibraryElement> libs) {
    return ImportableTypeResolverImpl(libs);
  }

  bool _hasConventionalMatch(ClassElement clazz) {
    if (clazz.isAbstract) {
      return false;
    }
    final fileName = clazz.source.shortName.replaceFirst('.dart', '');
    return (_classNameMatcher != null &&
            _classNameMatcher!.hasMatch(clazz.name)) ||
        (_fileNameMatcher != null && _fileNameMatcher!.hasMatch(fileName));
  }
}
