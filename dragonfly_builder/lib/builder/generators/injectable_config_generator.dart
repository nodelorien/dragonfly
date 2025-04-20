import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:dragonfly_annotations/dragonfly_annotations.dart';
import 'package:dragonfly_builder/builder/code_builder/library_builder.dart';
import 'package:dragonfly_builder/builder/models/dependency_config.dart';
import 'package:glob/glob.dart';
import 'package:source_gen/source_gen.dart';
import 'package:dragonfly_builder/builder/utils/hashed_allocator.dart';

class InjectableConfigGenerator
    extends GeneratorForAnnotation<DragonflyInjectableInit> {
  @override
  dynamic generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    final initializerName = annotation.read('initializerName').stringValue;
    final asExtension = annotation.read('asExtension').boolValue;
    final preferRelativeImports =
        annotation.read("preferRelativeImports").boolValue;
    final targetFile = element.source?.uri;

    // print(" [generate_for_for] $jsonAssets");

    final generateForDir = annotation
        .read('generateForDir')
        .listValue
        .map((e) => e.toStringValue());

    // print("====>>>> genetateForDir ${generateForDir}");

    final dirPattern = generateForDir.length > 1
        ? '{${generateForDir.join(',')}}'
        : '${generateForDir.first}';

    final injectableConfigFiles = Glob("$dirPattern/**.injectable.json");

    //print(
    //   "===>>>> dig pattern ($dirPattern) - configFiles: $injectableConfigFiles");

    final jsonData = <Map>[];
    await for (final id in buildStep.findAssets(injectableConfigFiles)) {
      // print("===>>>> how many vueltas ===>>> ${id.path}");
      final json = jsonDecode(await buildStep.readAsString(id));
      jsonData.addAll([...json]);
    }

    // print("====>>>> data ==> ${jsonData}");

    final deps = <DependencyConfig>[];
    for (final json in jsonData) {
      deps.add(DependencyConfig.fromJson(json));
    }

    // print("====>>>> deps ==> ${deps}");

    final generator = LibraryGenerator(
      dependencies: List.of(deps),
      targetFile: preferRelativeImports ? targetFile : null,
      initializerName: initializerName,
      asExtension: asExtension,
      microPackageName: null,
    );

    final generatedLib = generator.generate();
    final emitter = DartEmitter(
      allocator: HashedAllocator(),
      orderDirectives: true,
      useNullSafetySyntax: true,
    );

    final output =
        DartFormatter().format(generatedLib.accept(emitter).toString());
    return output;
  }
}
