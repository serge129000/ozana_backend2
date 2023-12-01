import 'package:dart_frog/dart_frog.dart';

import '../../../../../../data/repository_impl/user_repository_impl.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final rq = await UserRepositoryImpl().getAllPosts(id: int.parse(id));
  return Response.json(
    statusCode: rq.statusCode(),
    body: rq.toJson(),
  );
}
