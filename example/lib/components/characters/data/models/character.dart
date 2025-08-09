import 'package:dragonfly/dragonfly.dart';
import 'package:dragonfly_annotations/dragonfly_annotations.dart';
import 'package:example/components/characters/data/models/location.dart';
import 'package:example/components/characters/data/models/origin.dart';

part 'character.model.dart';

@FactoryModel()
abstract interface class Character implements _$CharacterContract {
  factory Character({
    @Field(field: "id", value: 123) required int id,
    required String name,
    required String status,
    required String species,
    required String type,
    required String gender,
    required Origin origin,
    required Location location,
    required String image,
    required List<String> episode,
    required String url,
    required String created,
  }) = _$Character;

  factory Character.fromJson(Map<String, Object?> value) = _$Character.fromJson;
}
