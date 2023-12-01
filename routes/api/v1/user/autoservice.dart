import 'dart:async';

import 'package:dart_frog/dart_frog.dart';

import '../../../../data/functions/encryptor.dart';

Future<Response> onRequest(RequestContext context) async {
  await AutoServices.allAutoServices();
  return Response.json();
}
