import 'package:dragonfly/framework/contracts/domain/use_case.dart';
import 'package:dragonfly/framework/functional/either.dart';
import 'package:dragonfly_annotations/annotations/injectable/injectable_annotations.dart';
import 'package:dragonfly_annotations/dragonfly_annotations.dart';

// Test singleton
@Singleton()
class DatabaseService {
  const DatabaseService();

  void connect() {
    print('Connected to database');
  }
}

// Test lazy singleton
@LazySingleton()
class CacheService {
  const CacheService();

  void cache(String key, String value) {
    print('Cached $key: $value');
  }
}

// Test factory with dependency
@Injectable()
class UserService {
  final DatabaseService database;
  final CacheService cache;

  const UserService(this.database, this.cache);

  void getUser(String id) {
    database.connect();
    cache.cache('user:$id', 'data');
  }
}

// Test use case
@UseCaseComponent()
class GetUserUseCase implements UseCase {
  final UserService userService;

  const GetUserUseCase(this.userService);

  void call(String userId) {
    userService.getUser(userId);
  }

  @override
  Future<Either<dynamic, dynamic>> exec(params) {
    // TODO: implement exec
    throw UnimplementedError();
  }
}
