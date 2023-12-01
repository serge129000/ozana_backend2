import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../../../../../data/repository_impl/user_repository_impl.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final dt = await context.request.formData();
  final file = dt.files['assets'];
  if (file == null || file.contentType.mimeType != file.contentType.mimeType) {
    return Response(statusCode: HttpStatus.badRequest);
  }
  try {
    final extension = file.name.split('.').last;
    final assetName = file.name.split('.').first;
    //print('$assetName.$extension');
    final imageFile = await File(
            '${Directory.current.path}/public/posts/${"$assetName.$extension"}')
        .create();
    await imageFile.writeAsBytes(await file.readAsBytes());
    final rp = await UserRepositoryImpl()
        .addUserPost(id: int.parse(id), imageName: '$assetName.$extension');
    return Response.json(statusCode: rp.statusCode(), body: rp.toJson());
  } catch (e) {
    rethrow;
  }
}
