import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import '../../../../data/repository_impl/user_repository_impl.dart';

Future<Response> onRequest(RequestContext context) async {
  final data = jsonDecode(await context.request.body());
  return Response.json(
    body: await UserRepositoryImpl().getAllUsers(token: data['token'].toString())
    ..toJson()
  );
}
