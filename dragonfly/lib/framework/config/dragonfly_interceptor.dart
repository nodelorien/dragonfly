import 'package:dragonfly/framework/network/exceptions/dragonfly_http_exception.dart';

class DragonflyInterceptor {
  final Object Function(Object options, Object)? before;
  final Object Function(Object response, Object handler)? after;
  final void Function(DragonflyHttpException e, Error handler)? catchError;

  const DragonflyInterceptor({this.before, this.after, this.catchError});
}
