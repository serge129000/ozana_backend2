// ignore_for_file: lines_longer_than_80_chars, avoid_dynamic_calls

import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import '../../../../data/repository_impl/user_repository_impl.dart';

Future<Response> onRequest(RequestContext requestContext) async {
  if (requestContext.request.method != HttpMethod.post) {
    return Response(statusCode: 401);
  }
  final userRepositoryImpl = UserRepositoryImpl();
  final data = jsonDecode(await requestContext.request.body());
  final rp = await userRepositoryImpl.loginNewUser(
      phone: data['phone'].toString(), password: data['password'].toString());
  if (rp.statusCode() != 200) {
    return Response.json(
      statusCode: rp.statusCode(),
      body: rp.toJson(),
    );
  }
  return Response.json(
    body: rp.toJson(),
  );
}
