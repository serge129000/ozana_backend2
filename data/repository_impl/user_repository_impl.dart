// ignore_for_file: leading_newlines_in_multiline_strings, lines_longer_than_80_chars, avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../database/postgresql_instance.dart';
import '../../models/error_respnse.dart';
import '../../models/profile.dart';
import '../../models/response.dart';
import '../../models/sucess_response.dart';
import '../../models/user.dart';
import '../functions/encryptor.dart';
import '../repository/user_repository.dart';
import '../utils/utils.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<QueryResponse> loginNewUser(
      {required String phone, required String password}) async {
    try {
      final db = PostGreSqlInstance.settings;
      await PostGreSqlInstance.init();
      /* final encryptedPassword = AesEncryptionService(AesEncryptionService.key)
          .encrypt(password)
          .base64;
      final decryptedPassword = AesEncryptionService(AesEncryptionService.key)
          .decrypt(Encrypted.fromBase64(encryptedPassword));
      if (decryptedPassword != password) {
        return ErrorResponse(
            message: 'any user match', requestCode: HttpStatus.forbidden);
      } */
      final sql =
          "SELECT id from utilisateurs where phone = '$phone' AND mot_de_passe = '$password' ;";
      final data = await db.mappedResultsQuery(sql);
      if (data.isEmpty) {
        return ErrorResponse(
            message: 'any user match', requestCode: HttpStatus.forbidden);
      }
      // ignore: omit_local_variable_types
      int id = 0;
      for (final element in data) {
        id = int.parse(element['utilisateurs']!['id'].toString());
      }

      final token = AesEncryptionService.generateToken(id: id);
      final sql2 =
          "update utilisateurs set access_token = '$token' where id = $id;";
      await db.query(sql2);

      return SuccesResponse(
        data: {
          'token': token,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<QueryResponse> registerNewuser(
      {required Utilisateurs utilisateurs}) async {
    try {
      final db = PostGreSqlInstance.settings;
      await PostGreSqlInstance.init();
      final sql =
          "insert into utilisateurs(nom, prenom, email, sexe, typeChretien, ville, pays, naissance, civilite, origine, langue, phone, mot_de_passe, premium, likecounter) values ('${utilisateurs.profile.nom}', '${utilisateurs.profile.prenom}', '${utilisateurs.email}', '${utilisateurs.profile.sexe}', '${utilisateurs.profile.typeChretien}', '${utilisateurs.profile.ville}', '${utilisateurs.profile.pays}', '${utilisateurs.profile.dateNaissance}', '${utilisateurs.profile.civilite}', '${utilisateurs.profile.origine}', '${utilisateurs.profile.langue}', '${utilisateurs.phone}', '${/* AesEncryptionService(AesEncryptionService.key).encrypt(utilisateurs.password).base64 */ utilisateurs.password}', '${utilisateurs.profile.hasPremium}', 2);";
      //print();
      await db.execute(sql);
      //print(rs);
      final queryResponse = await UserRepositoryImpl().loginNewUser(
        phone: utilisateurs.phone,
        password: utilisateurs.password,
      );
      print(queryResponse.toJson());
      return queryResponse;
    } catch (e) {
      print(e);
      return ErrorResponse(
          message: 'Echec lors de linscription',
          requestCode: HttpStatus.badRequest);
    }
  }

  @override
  Future<QueryResponse> addProfilPic(
      {required String token, required String imageName}) async {
    try {
      final db = PostGreSqlInstance.settings;
      await PostGreSqlInstance.init();
      final sql =
          "update utilisateurs set profil = '$imageName' where access_token = '$token';";
      final sql2 = "select id from utilisateurs where access_token = '$token';";
      final rs = await db.mappedResultsQuery(sql2);
      final id = rs.single['utilisateurs']!['id'];
      await UserRepositoryImpl()
          .addUserPost(id: int.parse(id.toString()), imageName: imageName);
      return SuccesResponse(data: await db.query(sql));
    } catch (e) {
      return ErrorResponse(message: '$e', requestCode: HttpStatus.badRequest);
    }
  }

  @override
  Future<QueryResponse> addAccessToken(
      {required String token, required int id}) async {
    try {
      final db = PostGreSqlInstance.settings;
      await PostGreSqlInstance.init();
      final sql =
          "update utilisateurs set access_token = '$token' where id = $id";
      return SuccesResponse(data: await db.query(sql));
    } catch (e) {
      return ErrorResponse(message: '$e', requestCode: HttpStatus.badRequest);
    }
  }

  @override
  Future<QueryResponse> getUser({required String token}) async {
    try {
      final db = PostGreSqlInstance.settings;
      await PostGreSqlInstance.init();
      final sql =
          "SELECT id, phone, nom, prenom, sexe, typeChretien, profil, ville, pays, naissance, civilite, langue, origine, premium AS hasPremium, validity, likecounter FROM utilisateurs where access_token = '$token';";
      final rs = await db.mappedResultsQuery(sql);
      if (rs.isEmpty) {
        return ErrorResponse(
            requestCode: HttpStatus.notFound,
            message: 'Aucun utilisateur ne correspond a ces donnees');
      }
      return SuccesResponse(data: rs);
    } catch (e) {
      return ErrorResponse(
          message: e.toString(), requestCode: HttpStatus.badRequest);
    }
  }

  @override
  Future<QueryResponse> getAllUsers({required String token}) async {
    try {
      final db = PostGreSqlInstance.settings;
      await PostGreSqlInstance.init();
      final sql =
          '''SELECT id, phone, nom, prenom, sexe, typeChretien, profil, ville, pays, naissance, civilite, langue, origine, premium AS hasPremium, validity 
          FROM utilisateurs 
          WHERE access_token != '$token'
          ORDER BY RANDOM()
          ''';
      return SuccesResponse(data: await db.mappedResultsQuery(sql));
    } catch (e) {
      return ErrorResponse(
          message: e.toString(), requestCode: HttpStatus.badRequest);
    }
  }

  @override
  Future<QueryResponse> addUserPost(
      {required int id, required String imageName}) async {
    try {
      final db = PostGreSqlInstance.settings;
      await PostGreSqlInstance.init();
      final sql =
          "insert into publications (user_id, date_publication, contenu_publication) values($id, ${DateTime.now().millisecondsSinceEpoch}, '$imageName')";
      await db.execute(sql);
      return SuccesResponse(data: 'Post enregistre avec succes');
    } catch (e) {
      print(e);
      return ErrorResponse(
          message: 'Erreur', requestCode: HttpStatus.badRequest);
    }
  }

  @override
  Future<QueryResponse> getAllPosts({required int id}) async {
    try {
      final db = PostGreSqlInstance.settings;
      await PostGreSqlInstance.init();
      final sxSql = 'select sexe from utilisateurs where id = $id';
      final List<Map<String, Map>> data = await db.mappedResultsQuery(sxSql);
      /* SELECT p.*
FROM publication p
JOIN utilisateur u ON p.user_id = u.id
WHERE u.sexe = 'M' AND u.id = 1;
 */
      final sql = '''SELECT p.*
FROM publications p
JOIN utilisateurs u ON p.user_id = u.id
WHERE u.sexe != '${data.single["utilisateurs"]!["sexe"]}' AND u.id != $id ORDER BY RANDOM()''';
      //print(sql);
      return SuccesResponse(data: await db.mappedResultsQuery(sql));
    } catch (e) {
      print(e);
      return ErrorResponse(
        message: 'Erreur lors de la recuperation des posts',
        requestCode: HttpStatus.badRequest,
      );
    }
  }

  @override
  Future<QueryResponse> getAllPackage() async {
    try {
      final db = PostGreSqlInstance.settings;
      await PostGreSqlInstance.init();
      const sql = 'select * from package';
      final List<Map<String, dynamic>> data = await db.mappedResultsQuery(sql);
      return SuccesResponse(data: data);
    } catch (e) {
      return ErrorResponse(
          message: 'Erreur lors de la recuperation de packages',
          requestCode: HttpStatus.badRequest);
    }
  }

  @override
  Future<QueryResponse> suscribeUser({required String id}) async {
    try {
      final db = PostGreSqlInstance.settings;
      await PostGreSqlInstance.init();
      final response = await http.get(
        Uri.parse('https://api.fedapay.com/v1/transactions/$id'),
        headers: {
          'Authorization': 'Bearer ${PostGreSqlInstance.fedapayLiveKey}'
        },
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        //print(response.statusCode);
        throw Exception('Une erreur s\est produite');
      }
      final data = jsonDecode(response.body);
      final amount = data['v1/transaction']['amount'];
      final status = data['v1/transaction']['status'];
      // ignore: no_leading_underscores_for_local_identifiers
      final _amount = int.parse(amount.toString()).toDouble();
      //print(status);
      final sql = 'select * from package where prix = $_amount';
      final rp = await db.mappedResultsQuery(sql);
      final duration = rp.single['package']!['duration'];
      final durationGet = durationKToString[duration]!;
      /*  print(status['status']);
      print(status['status']! == 'approved'); */
      if (status == 'approved') {
        final sql = '''UPDATE utilisateurs
      SET premium = true, validity = ${accordingToDurationK(durationK: durationGet).millisecondsSinceEpoch}
      WHERE paiement_id = $id;
      ''';
        await db.execute(sql);
      } else {
        throw Exception('echec de la transaction');
      }
      return SuccesResponse(data: []);
    } catch (e) {
      //print(e);
      return ErrorResponse(
          message: e.toString(), requestCode: HttpStatus.badRequest);
    }
  }

  @override
  Future<QueryResponse> saveTransactionId(
      {required int id, required String token}) async {
    try {
      final db = PostGreSqlInstance.settings;
      await PostGreSqlInstance.init();
      final sql = '''UPDATE utilisateurs
      SET paiement_id = $id
      WHERE access_token = '$token';
      ''';
      await db.execute(sql);
      return SuccesResponse(data: 'Transaction Sauvegarder');
    } catch (e) {
      return ErrorResponse(
          message: 'Erreur lors de la saugarde de la transaction',
          requestCode: HttpStatus.badRequest);
    }
  }

  @override
  Future<void> checkValidityOfPremiumAccount() async {
    try {
      final db = PostGreSqlInstance.settings;
      await PostGreSqlInstance.init();
      const sql = 'select id, validity from utilisateurs where premium = true';
      final res = await db.mappedResultsQuery(sql);
      for (final element in res) {
        if (DateFormat('dd-MMMM-yyyy').format(
                DateTime.fromMillisecondsSinceEpoch(int.parse(
                    element['utilisateurs']!['validity'].toString()))) ==
            DateFormat('dd-MMMM-yyyy').format(DateTime.now())) {
          print('user_found');
          final sql2 =
              'update utilisateurs set premium = false where id = ${element["utilisateurs"]!["id"]};';
          await db.execute(sql2);
        } else {
          print('nobody found');
        }
      }
    } catch (e) {
      //print(e);
    }
  }

  @override
  Future<void> addNewLikeForTheDay() async {
    try {
      final db = PostGreSqlInstance.settings;
      await PostGreSqlInstance.init();
      const sql = 'select id from utilisateurs';
      final rs = await db.mappedResultsQuery(sql);
      for (final element in rs) {
        final sql2 =
            'update utilisateurs set likecounter = 10 where id = ${element["utilisateurs"]!["id"]};';
        await db.execute(sql2);
      }
    } catch (e) {
      //print(e);
      rethrow;
    }
  }

  @override
  Future<void> decrementLikeForNonPremium({required int id}) async {
    try {
      final db = PostGreSqlInstance.settings;
      await PostGreSqlInstance.init();
      // ignore: omit_local_variable_types, no_leading_underscores_for_local_identifiers
      int _counter = 0;
      final sql = 'select likecounter from utilisateurs where id = $id';
      final rs = await db.mappedResultsQuery(sql);
      //print(rs);
      var counter =
          int.parse(rs.single['utilisateurs']!['likecounter'].toString());
      if (counter > 0) {
        _counter = counter -= 1;
        final sql2 =
            'update utilisateurs set likecounter = $_counter where id = $id';
        await db.execute(sql2);
      }
    } catch (e) {
      //print(e);
      rethrow;
    }
  }

  @override
  Future<QueryResponse> updateUserPersonnalsInfos({
    required int id,
    required Profile profile,
  }) async {
    try {
      final db = PostGreSqlInstance.settings;
      await PostGreSqlInstance.init();
      final sql =
          "update utilisateurs set nom = '${profile.nom}', prenom = '${profile.prenom}', civilite = '${profile.civilite}', origine = '${profile.origine}', langue = '${profile.langue}' where id = $id;";
      await db.execute(sql);
      return SuccesResponse(data: []);
    } catch (e) {
      return ErrorResponse(
        message: e.toString(),
        requestCode: HttpStatus.badRequest,
      );
    }
  }

  @override
  Future<QueryResponse> updateUserPassword(
      {required int id,
      required String oldPassword,
      required String newPassword}) async {
    try {
      final db = PostGreSqlInstance.settings;
      await PostGreSqlInstance.init();
      final sql = 'select mot_de_passe from utilisateurs where id = $id';
      final rs = await db.mappedResultsQuery(sql);
      /* final decryptedPassword = AesEncryptionService(AesEncryptionService.key)
          .decrypt(Encrypted.fromBase64(
              rs.single['utilisateurs']!['mot_de_passe'].toString())); */
      final password = rs.single['utilisateurs']!['mot_de_passe'].toString();
      if (password != oldPassword) {
        return ErrorResponse(
            message: 'les mots de passes ne correspondent pas',
            requestCode: HttpStatus.notFound);
      }
      final sql2 =
          "update utilisateurs set mot_de_passe = '${newPassword /* AesEncryptionService(AesEncryptionService.key).encrypt(newPassword).base64 */}'";
      await db.execute(sql2);
      return SuccesResponse(data: []);
    } catch (e) {
      return ErrorResponse(
          message: e.toString(), requestCode: HttpStatus.notFound);
    }
  }

  @override
  Future<QueryResponse> deleteUserAccount({required String token}) async {
    try {
      final db = PostGreSqlInstance.settings;
      await PostGreSqlInstance.init();
      final sql = "select id from utilisateurs where access_token = '$token'";
      final data = await db.mappedResultsQuery(sql);
      final id = data.single['utilisateurs']!['id'];
      final sql1 = 'delete from publications where user_id = $id';
      final sql2 = 'delete from utilisateurs where id = $id';
      await db.execute(sql1);
      await db.execute(sql2);
      return SuccesResponse(data: <dynamic>[]);
    } catch (e) {
      return ErrorResponse(
        message: e.toString(),
        requestCode: HttpStatus.badRequest,
      );
    }
  }

  @override
  Future<http.Response> sendSms(
      {required String message, required String to}) async {
    final response = await http.post(
      Uri.parse(
        'https://edok-api.kingsmspro.org/api/v1/sms/send',
      ).replace(
        queryParameters: {
          'from': 'OZANA',
          'to': to,
          'type': '1',
          'dlr': 'no',
          'message': message,
        },
      ),
      headers: {
        'CLIENTID': '4114',
        'APIKEY': 'lY9Z68pFnA5EnJ72fM3fH2sT4aNDSDvK',
        'Content-Type': 'application/json'
      },
    );
    return response;
  }

  @override
  Future<QueryResponse> authPhoneNumber({required String phone}) async {
    try {
      final db = PostGreSqlInstance.settings;
      await PostGreSqlInstance.init();
      final sql = "select * from utilisateurs where phone = '$phone'";
      final data = await db.mappedResultsQuery(sql);
      if (data.isEmpty) {
        final random = Random();
        final code = 100000 + random.nextInt(900000);
        //print('Votre code pour vous authentifier sur OZANA est $code');
        await sendSms(
          message: 'Votre code pour vous authentifier sur OZANA est $code',
          to: phone.replaceAll('+', ''),
        );
        final sql2 = "select * from authcode where numero = '$phone'";
        final secondData = await db.mappedResultsQuery(sql2);
        if (secondData.isEmpty) {
          final sql2 =
              "insert into authcode(numero, code) values ('$phone', '$code')";
          await db.execute(sql2);
        } else {
          final sql2 =
              "update authcode set code = '$code' where numero = '$phone'";
          await db.execute(sql2);
        }
        return SuccesResponse(data: data);
      } else {
        return ErrorResponse(
          message: 'Vous avez deja un compte veuillez vous reconnecter',
          requestCode: HttpStatus.forbidden,
        );
      }
    } catch (e) {
      return ErrorResponse(
        message: e.toString(),
        requestCode: HttpStatus.internalServerError,
      );
    }
  }

  @override
  Future<QueryResponse> checkSmsCode({
    required String code,
    required String phone,
  }) async {
    try {
      final db = PostGreSqlInstance.settings;
      await PostGreSqlInstance.init();
      final sql =
          "select * from authcode where numero = '$phone' AND code = '$code';";
      final data = await db.mappedResultsQuery(sql);
      if (data.isEmpty) {
        return ErrorResponse(
          message: 'Code incorrect',
          requestCode: HttpStatus.badRequest,
        );
      }
      return SuccesResponse(data: 'Code executer avec succes');
    } catch (e) {
      return ErrorResponse(
        message: e.toString(),
        requestCode: HttpStatus.internalServerError,
      );
    }
  }

  @override
  Future<QueryResponse> resetPasswordCode({required String phone}) async {
    try {
      final db = PostGreSqlInstance.settings;
      await PostGreSqlInstance.init();
      final sql = "select * from utilisateurs where phone = '$phone'";
      final data = await db.mappedResultsQuery(sql);
      if (data.isNotEmpty) {
        final random = Random();
        final code = 100000 + random.nextInt(900000);
        //print('Votre code pour vous authentifier sur OZANA est $code');
        await sendSms(
          message: 'Votre code pour vous authentifier sur OZANA est $code',
          to: phone.replaceAll('+', ''),
        );
        final sql2 = "select * from authcode where numero = '$phone'";
        final secondData = await db.mappedResultsQuery(sql2);
        if (secondData.isEmpty) {
          final sql2 =
              "insert into authcode(numero, code) values ('$phone', '$code')";
          await db.execute(sql2);
        } else {
          final sql2 =
              "update authcode set code = '$code' where numero = '$phone'";
          await db.execute(sql2);
        }
        return SuccesResponse(data: data);
      } else {
        return ErrorResponse(
          message: 'Vous avez deja un compte veuillez vous reconnecter',
          requestCode: HttpStatus.forbidden,
        );
      }
    } catch (e) {
      return ErrorResponse(
        message: e.toString(),
        requestCode: HttpStatus.internalServerError,
      );
    }
  }

  @override
  Future<QueryResponse> resetPassword(
      {required String password, required String phone}) async {
    try {
      final db = PostGreSqlInstance.settings;
      await PostGreSqlInstance.init();
      final sql =
          "update utilisateurs set mot_de_passe = '$password' where phone = '$phone'";
      await db.execute(sql);
      return SuccesResponse(data: {});
    } catch (e) {
      return ErrorResponse(
          message: "Une erreur s'est produite",
          requestCode: HttpStatus.badRequest);
    }
  }
}
