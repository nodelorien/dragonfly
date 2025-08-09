import 'package:analyzer/dart/element/element2.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:dragonfly_annotations/annotations/component/repositoriy/repository.dart';
import 'package:dragonfly_builder/builder/types/enums/http_annotations.dart';
import 'package:dragonfly_builder/builder/types/method_repository_type.dart';
import 'package:dragonfly_builder/builder/visitor/repository_visitor.dart';
import 'package:source_gen/source_gen.dart';

class RepositoryGenerator extends GeneratorForAnnotation<Repository> {
  String url = '';
  String connection = '';
  bool localMethods = false;

  RepositoryGenerator();

  @override
  String generateForAnnotatedElement(
      Element2 element, ConstantReader annotation, BuildStep buildStep) {
    final visitor = RepositoryVisitor();

    element.visitChildren2(visitor);

    final className = visitor.className;

    url = annotation.peek('url')?.stringValue ?? '';
    connection = annotation.peek('connection')?.stringValue ?? '';

    for (MethodRepositoryType method in visitor.methods) {
      return buildHttpMethod(url, connection, className, method);
    }
    return "_no_code";
  }

  String _getHttpMethod(HttpAnnotations http) {
    return switch (http) {
      HttpAnnotations.post => "HttpMethods.post",
      HttpAnnotations.patch => "HttpMethods.patch",
      HttpAnnotations.put => "HttpMethods.put",
      HttpAnnotations.delete => "HttpMethods.delete",
      HttpAnnotations.get => "HttpMethods.get",
      _ => ""
    };
  }

  String buildHttpMethod(String repoUrl, String repoConn, String className,
      MethodRepositoryType method) {
    final methodKind =
        method.returnType.isList ? "callForList" : "callForObject";
    final bool isList = method.returnType.isList;
    final String httpMethod = _getHttpMethod(method.type);
    final String returnType = method.returnType.isList
        ? "List<Map<String, Object?>>"
        : "Map<String, Object?>";

    final String response = isList
        ? buildResponseWhenIsList(method)
        : buildResponseWhenIsObject(method);

    final animal = Class((b) => b
      ..name = "_$className"
      ..implements.add(refer(className))
      // ..extend = refer('Organism')
      ..methods.add(Method((b) => b
        ..name = method.name
        ..requiredParameters
            .addAll(method.params.map((param) => Parameter((p) => p
              ..name = param.name
              ..type = refer(param.paramDataType))))
        ..modifier = MethodModifier.async
        ..annotations.add(refer('override'))
        ..returns = refer(method.returnType.raw)
        ..body = Code("final DragonflyNetworkHttpAdapter network = "
            "DragonflyContainer().get<DragonflyNetworkHttpAdapter>(instanceName: '__http__$repoConn'); \n"
            "final $returnType response = await network.$methodKind($httpMethod, '$repoUrl${method.path}', null, null);\n"
            "$response;\n"
            ""))));

    final emitter = DartEmitter();
    return DartFormatter(languageVersion: DartFormatter.latestLanguageVersion)
        .format('${animal.accept(emitter)}');
  }

  String buildResponseWhenIsList(MethodRepositoryType method) {
    String modelName = method.returnType.modelName;
    return "return response.map((e) => $modelName.fromJson(e)) as List<$modelName>";
  }

  String buildResponseWhenIsObject(MethodRepositoryType method) {
    String modelName = method.returnType.modelName;
    return "return $modelName.fromJson(response)";
  }

  String getMapperWhenMethodIsList() {
    return "";
  }
}
