// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:dragonfly/dragonfly.dart';

import 'package:example/test_injectable.dart';
import 'package:example/components/characters/domain/use_cases/get_user_list_use_case.dart';
import 'package:example/components/characters/data/repositories/character_repository.dart';

extension DragonflyContainerConfigX on DragonflyContainer {
  Future<void> configureDependencies() async {
    final gh = DragonflyContainer();

    // Factories
    gh.registerFactory<GetUserUseCase>(
      () => GetUserUseCase(gh.get<UserService>()),
    );
    gh.registerFactory<GetUserListUseCase>(
      () => GetUserListUseCase(gh.get<CharacterRepository>()),
    );
  }
}
