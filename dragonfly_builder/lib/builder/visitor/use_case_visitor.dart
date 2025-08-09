import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/visitor2.dart';
import '../types/method_repository_type.dart';
import '../helper/metadata_extractor.dart';

class UseCaseVisitor extends SimpleElementVisitor2<void> {
  late String className;
  final fields = <String, dynamic>{};
  final Map<String, dynamic> metaData = {};
  final List<MethodRepositoryType> methods = [];

  @override
  void visitConstructorElement(ConstructorElement2 element) {
    final elementReturnType = element.type.returnType.toString();
    className = elementReturnType.replaceFirst('*', '');
  }

  @override
  void visitFieldElement(FieldElement2 element) {}

  @override
  void visitClassElement(ClassElement2 classElement) {}

  @override
  void visitMethodElement(MethodElement2 element) {
    String name = element.displayName;
    String path = MedatadaExtractor.getAnnotationMethodField(element, 'path');
  }
}
