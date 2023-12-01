import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import '../../../../data/repository_impl/user_repository_impl.dart';

Future<Response> onRequest(RequestContext context) async {
  final data = jsonDecode(await context.request.body());
  print(data["id"]);
  await UserRepositoryImpl()
      .decrementLikeForNonPremium(id: int.parse(data['id'].toString()));
  return Response();
}
