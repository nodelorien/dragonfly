import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/visitor2.dart';
import '../types/method_repository_type.dart';
import '../types/return_type.dart';
import 'header_helper.dart';
import '../helper/metadata_extractor.dart';
import 'parameter_helper.dart';
import 'return_helper.dart';

class RepositoryVisitor extends SimpleElementVisitor2<void> {
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
  void visitFieldElement(FieldElement2 element) {
    final elementType = element.type.toString();
    fields[element.displayName] = elementType.replaceFirst('*', '');
    metaData[element.displayName] = element.metadata2;
  }

  @override
  void visitClassElement(ClassElement2 classElement) {}

  @override
  void visitMethodElement(MethodElement2 element) {
    String name = element.displayName;
    String path = MedatadaExtractor.getAnnotationMethodField(element, 'path');

    Map<DartObject, DartObject>? headers =
        MedatadaExtractor.getAnnotationMethodField(element, 'headers');

    final String returnName = element.returnType.getDisplayString();

    element.children2.map((e) {
      print("===>>>>> fragment ${e}");
    });

    print("====>>>>> RETURNs > ${element.returnType}");

    methods.add(MethodRepositoryType(
        name: name,
        params: ParameterHelper().parametersResolver(element.formalParameters),
        path: path,
        returnType: ReturnType(
            modelName: ReturnHelper().getTypeFromReturn(returnName),
            raw: returnName,
            isList: ReturnHelper().isReturnList(returnName)),
        type: MedatadaExtractor.getMethodType(element),
        headers: HeaderHelper().fromDartObject2HeaderType(headers),
        isFuture: false));
  }
}
