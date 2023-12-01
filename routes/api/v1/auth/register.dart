import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import '../../../../data/repository_impl/user_repository_impl.dart';
import '../../../../models/user.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(
      statusCode: 101,
      body: 'Unauthorized',
    );
  }
  final userRepositoryImpl = UserRepositoryImpl();
  final utilisateur =
      Utilisateurs.fromJson(jsonDecode(await context.request.body()));
  final rp =
      await userRepositoryImpl.registerNewuser(utilisateurs: utilisateur);
  return Response.json(
    statusCode: rp.statusCode(),
    body: rp..toJson(),
  );
}
