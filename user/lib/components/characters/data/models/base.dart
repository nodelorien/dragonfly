import 'package:dragonfly_annotations/dragonfly_annotations.dart';
import 'package:user/components/characters/data/models/character.dart';
import 'package:user/components/characters/data/models/info.dart';
import 'package:dragonfly/dragonfly.dart';

part 'base.model.dart';

@FactoryModel()
abstract interface class Base implements _$BaseContract {
  factory Base({required Info info, required List<Character> results}) = _$Base;
  factory Base.fromJson(Map<String, Object?> value) = _$Base.fromJson;
}
