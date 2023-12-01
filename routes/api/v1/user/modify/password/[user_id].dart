import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import '../../../../../../data/repository_impl/user_repository_impl.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final data = jsonDecode(await context.request.body());
  final dt = await UserRepositoryImpl().updateUserPassword(
      id: int.parse(id),
      oldPassword: data['oldPassword'].toString(),
      newPassword: data['newPassword'].toString());
  return Response.json(
    statusCode: dt.statusCode(),
    body: dt.toJson(),
  );
}
