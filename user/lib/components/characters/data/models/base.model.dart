// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base.dart';

// **************************************************************************
// FactoryModelGenerator
// **************************************************************************

class _$Base implements FactoryModelWatcher, Base {
  _$Base({
    required this.info,
    required this.results,
  });

  factory _$Base.fromJson(Map<String, Object?> json) {
    return _$Base(
        info: Info.fromJson(
          json['info'] as Map<String, Object?>,
        ),
        results: JsonDatatypeMapper.mapGenericList<Character>(
            json['results'] as List,
            (e) => Character.fromJson(e as Map<String, Object?>)));
  }

  final Info info;

  final List<Character> results;
}

abstract class _$BaseContract {
  Info get info;

  List<Character> get results;
}
