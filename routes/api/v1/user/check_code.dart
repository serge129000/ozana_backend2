// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import '../../../../data/repository_impl/user_repository_impl.dart';

Future<Response> onRequest(RequestContext context) async {
  final data = jsonDecode(await context.request.body());
  final phone = data['phone'].toString();
  final code = data['code'].toString();
  final rq = await UserRepositoryImpl().checkSmsCode(phone: phone, code: code);
  return Response.json(statusCode: rq.statusCode(), body: rq.toJson());
}
