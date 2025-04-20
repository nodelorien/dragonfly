import 'package:dragonfly_annotations/dragonfly_annotations.dart';
import 'package:dragonfly/dragonfly.dart';
import 'package:user/components/characters/data/models/info.dart';

part 'service_response.model.dart';

@FactoryModel(generic: true)
abstract interface class ServiceResponse<T>
    implements _$ServiceResponseContract<T> {
  factory ServiceResponse({
    required Info info,
    required List<T> result,
  }) = _$ServiceResponse;

  factory ServiceResponse.fromJson(
          Map<String, Object?> value, T Function(Object? json) fromJsonT) =
      _$ServiceResponse.fromJson;
}
