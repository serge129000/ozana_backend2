import 'package:dart_frog/dart_frog.dart';

import '../../../../data/repository_impl/user_repository_impl.dart';

Future<Response> onRequest(RequestContext context) async {
  final data = context.request.uri.queryParameters;
  //print(data);
  return Response.json(
      body: await UserRepositoryImpl().suscribeUser(id: data['id'].toString()));
}
//ce queje veux faire c'est de checker par transaction