import 'package:analyzer/dart/element/element2.dart';
import 'package:dragonfly_builder/builder/types/enums/params_annotations.dart';
import 'package:dragonfly_builder/builder/types/params_type.dart';

class ParameterHelper {
  List<ParamsType> parametersResolver(List<FormalParameterElement> parameters) {
    List<ParamsType> params = [];
    for (FormalParameterElement paramElement in parameters) {
      print("====>>>>>>>>> ${paramElement.type}");
      params.add(ParamsType(
          name: paramElement.displayName,
          paramDataType: "${paramElement.type}",
          value: paramElement.metadata2.annotations.first
              .toString()
              .split(" ")
              .first,
          type: ParamsAnnotations.path,
          valueType: ValueType.simple));
    }
    return params;
  }
}
