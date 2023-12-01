import '../../models/profile.dart';
import '../../models/response.dart';
import '../../models/user.dart';

abstract class UserRepository {
  Future<QueryResponse> registerNewuser({required Utilisateurs utilisateurs});
  Future<QueryResponse> loginNewUser(
      {required String phone, required String password});
  Future<QueryResponse> addProfilPic(
      {required String token, required String imageName});
  Future<QueryResponse> addAccessToken({
    required String token,
    required int id,
  });
  Future<QueryResponse> getUser({required String token});
  Future<QueryResponse> getAllUsers({required String token});
  Future<QueryResponse> addUserPost(
      {required int id, required String imageName});
  Future<QueryResponse> getAllPosts({required int id});
  Future<QueryResponse> getAllPackage();
  Future<QueryResponse> suscribeUser({required String id});
  Future<QueryResponse> saveTransactionId(
      {required int id, required String token});
  Future<void> checkValidityOfPremiumAccount();
  Future<void> addNewLikeForTheDay();
  Future<void> decrementLikeForNonPremium({required int id});
  Future<QueryResponse> updateUserPersonnalsInfos(
      {required int id, required Profile profile});
  Future<QueryResponse> updateUserPassword(
      {required int id,
      required String oldPassword,
      required String newPassword});
  Future<QueryResponse> deleteUserAccount({required String token});
}
