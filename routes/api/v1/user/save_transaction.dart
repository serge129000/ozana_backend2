// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import '../../../../data/repository_impl/user_repository_impl.dart';

Future<Response> onRequest(RequestContext context) async {
  final data = jsonDecode(await context.request.body());
  final rq = await UserRepositoryImpl().saveTransactionId(
      id: int.parse(data['id'].toString()), token: data['token'].toString());
  return Response.json(
    body: rq.toJson(),
    statusCode: rq.statusCode(),
  );
}
