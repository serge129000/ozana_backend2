import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import '../../../../../data/repository_impl/user_repository_impl.dart';
import '../../../../../models/profile.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final profile = Profile.fromJson(jsonDecode(await context.request.body()));
  print(profile.tojson());
  final dt = await UserRepositoryImpl()
      .updateUserPersonnalsInfos(id: int.parse(id), profile: profile);
  return Response.json(statusCode: dt.statusCode());
}
