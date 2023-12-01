import 'profile.dart';

class Utilisateurs {
  Utilisateurs({
    required this.userId,
    required this.profile,
    required this.password,
    required this.phone,
    this.email,
  });
  factory Utilisateurs.fromJson(_) => Utilisateurs(
      userId: int.tryParse(_['user_id'].toString()),
      profile: Profile.fromJson(_['profile']),
      password: _['mot_de_passe'].toString(),
      phone: _['phone'].toString(),);
  final int? userId;
  final String? email;
  final String phone;
  final String password;
  final Profile profile;
}
