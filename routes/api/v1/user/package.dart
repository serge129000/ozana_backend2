import 'package:dart_frog/dart_frog.dart';

import '../../../../data/repository_impl/user_repository_impl.dart';

Future<Response> onRequest(RequestContext context) async {
  final rq = await UserRepositoryImpl().getAllPackage();
  return Response.json(
  statusCode: rq.statusCode(),
  body: rq.toJson(),
);
}
