import 'package:dragonfly_annotations/dragonfly_annotations.dart';
import 'package:dragonfly/dragonfly.dart';
import 'package:user/components/characters/data/models/base.dart';

part "character_repository.repository.dart";

@Repository(url: "character")
abstract class CharacterRepository {
  factory CharacterRepository() = _CharacterRepository;

  @Get()
  Future<Base> getAll(@Path() String name, @Query() List<String> julian);
}
