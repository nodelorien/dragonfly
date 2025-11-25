import 'package:dragonfly/dragonfly.dart';
import 'package:dragonfly_annotations/annotations/component/domain/use_case_component.dart';
import 'package:example/components/characters/data/models/character.dart';
import 'package:example/components/characters/data/models/service_response.dart';
import 'package:example/components/characters/data/repositories/character_repository.dart';

@UseCaseComponent()
class GetUserListUseCase implements UseCase {
  final CharacterRepository userRepository;

  const GetUserListUseCase(this.userRepository);

  Future<ServiceResponse<Character>> call(
    String name,
    List<String> params,
  ) async {
    return await userRepository.getAll(name, params);
  }

  @override
  Future<Either<dynamic, dynamic>> exec(params) {
    // TODO: implement exec
    throw UnimplementedError();
  }
}
