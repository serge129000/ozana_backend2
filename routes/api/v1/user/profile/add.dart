// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../../../../data/repository_impl/user_repository_impl.dart';

Future<Response> onRequest(RequestContext context) async {
  print('Root in use');
  final dt = await context.request.formData();
  final file = dt.files['profilPic'];
  final token = dt.fields['token'];
  if (token == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }
  final date = DateTime.now();
  if (file == null || file.contentType.mimeType != file.contentType.mimeType) {
    return Response(statusCode: HttpStatus.badRequest);
  }
  try {
    final name = file.name;
    final imageFile = await File(
            '${Directory.current.path}/public/profiles/${name.substring(0, name.length - 4) + date.millisecond.toString()}.jpg')
        .create();
    final imageData = await file.readAsBytes();
    await imageFile.writeAsBytes(imageData);
    final postImageFile = await File(
            '${Directory.current.path}/public/posts/${name.substring(0, name.length - 4) + date.millisecond.toString()}.jpg')
        .create();
    await postImageFile.writeAsBytes(imageData);
    final rq = await UserRepositoryImpl().addProfilPic(
        token: token,
        imageName:
            '${name.substring(0, name.length - 4) + date.millisecond.toString()}.jpg');
    //print(rq);
    return Response.json(body: rq.toJson(), statusCode: rq.statusCode());
  } catch (e) {
    Response.json(statusCode: HttpStatus.badRequest);
    rethrow;
  }
}
