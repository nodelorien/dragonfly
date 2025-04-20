// import 'package:dragonfly/core/framework/contracts/functional/either.dart';

import 'package:dragonfly_annotations/dragonfly_annotations.dart';
import 'package:user/components/characters/data/models/character.dart';
import 'package:user/components/characters/data/repositories/character_repository.dart';

@UseCase()
class GetUserListUseCase {
  final CharacterRepository userRepository;

  const GetUserListUseCase({required this.userRepository});

  @override
  Future<void> exec(params) async {
    Future<Base<Character>> result = userRepository.getAll("", [""]);
  }
}
