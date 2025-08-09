import 'package:dragonfly_annotations/dragonfly_annotations.dart';
import 'package:dragonfly/dragonfly.dart';

part 'info.model.dart';

@FactoryModel()
abstract interface class Info implements _$InfoContract {
  factory Info(
      {required int count,
      required int pages,
      required String next,
      required String? prev}) = _$Info;

  factory Info.fromJson(Map<String, Object?> value) = _$Info.fromJson;
}
