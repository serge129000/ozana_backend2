import 'dart:async';
import 'dart:math';

import 'package:encrypt/encrypt.dart';

import '../repository_impl/user_repository_impl.dart';

class AesEncryptionService {
  AesEncryptionService(this._key) : _iv = IV.fromLength(16);
  final String _key;
  final IV _iv;
  static const key = '7afzTJd2vrGUT6UTlYMngA==';
  Encrypted encrypt(String plaintext) {
    final key = Key.fromUtf8(_key);
    final encrypter = Encrypter(AES(key));
    return encrypter.encrypt(plaintext, iv: _iv);
  }

  String decrypt(Encrypted ciphertext) {
    final key = Key.fromUtf8(_key);
    final encrypter = Encrypter(AES(key));
    return encrypter.decrypt(ciphertext, iv: _iv);
  }

  static String generateToken({required int id}) {
    final rsa = Random().nextInt(9999999);
    final plainText = '$rsa/ozana/+$id$key';
    final encrypter = Encrypter(AES(Key.fromBase64(key)));
    return encrypter.encrypt(plainText, iv: IV.fromLength(16)).base64;
  }
}

class AutoServices{
  static Future<void> allAutoServices() async{
    await UserRepositoryImpl().addNewLikeForTheDay();
    await UserRepositoryImpl().checkValidityOfPremiumAccount();
    Timer.periodic(const Duration(days: 1), (timer) async {
    await UserRepositoryImpl().addNewLikeForTheDay();
    await UserRepositoryImpl().checkValidityOfPremiumAccount();
  });
  }
}
