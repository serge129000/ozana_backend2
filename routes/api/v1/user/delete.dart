import 'dart:convert';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';

import '../../../../data/repository_impl/user_repository_impl.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.delete) {
    final data = jsonDecode(await context.request.body());
    final token = data['token'];
    final response =
        await UserRepositoryImpl().deleteUserAccount(token: token.toString());
    return Response.json(
        statusCode: response.statusCode(), body: response.toJson());
  } else {
    return Response.json(
      statusCode: HttpStatus.badGateway
    );
  }
}
