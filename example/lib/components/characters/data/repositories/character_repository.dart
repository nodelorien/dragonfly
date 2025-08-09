import 'package:dragonfly_annotations/dragonfly_annotations.dart';
import 'package:dragonfly/dragonfly.dart';
import 'package:example/components/characters/data/models/character.dart';
import 'package:example/components/characters/data/models/service_response.dart';

part "character_repository.repository.dart";

@Repository(url: "character")
abstract class CharacterRepository {
  factory CharacterRepository() = _CharacterRepository;

  @Get()
  Future<ServiceResponse<Character>> getAll(
    @Path() String name,
    @Query() List<String> julian,
  );
}
