import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../../../data/repository_impl/user_repository_impl.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response.json(
      statusCode: HttpStatus.forbidden,
    );
  }
  final data = jsonDecode(await context.request.body());
  final rq = await UserRepositoryImpl().getUser(token: data['token'].toString());
  return Response.json(
    statusCode: rq.statusCode(),
    body: rq
    ..toJson(),
  );
}
