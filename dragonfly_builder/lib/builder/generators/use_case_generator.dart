import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:build/build.dart';
import 'package:dragonfly_annotations/dragonfly_annotations.dart';
import 'package:dragonfly_builder/builder/visitor/use_case_visitor.dart';
import 'package:source_gen/source_gen.dart';

class UseCaseGenerator extends GeneratorForAnnotation<UseCase> {
  String url = '';
  String connection = '';
  bool localMethods = false;

  UseCaseGenerator();

  @override
  String generateForAnnotatedElement(
      Element2 element, ConstantReader annotation, BuildStep buildStep) {
    final visitor = UseCaseVisitor();

    element.visitChildren2(visitor);

    final className = visitor.className;

    url = annotation.peek('url')?.stringValue ?? '';
    connection = annotation.peek('connection')?.stringValue ?? '';

    return "_no_code";
  }
}
