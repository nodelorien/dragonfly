// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_repository.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

class _CharacterRepository implements CharacterRepository {
  @override
  Future<ServiceResponse<Character>> getAll(
    String name,
    List<String> julian,
  ) async {
    final DragonflyNetworkHttpAdapter network = DragonflyContainer()
        .get<DragonflyNetworkHttpAdapter>(instanceName: '__http__default');
    final Map<String, Object?> response =
        await network.callForObject(HttpMethods.get, 'character', null, null);
    return ServiceResponseCharacter.fromJson(response);
  }
}
