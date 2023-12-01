class Profile {
  Profile(
      {
      //required this.userId,
      required this.phone,
      required this.nom,
      required this.prenom,
      required this.sexe,
      required this.typeChretien,
      required this.photoProfil,
      required this.ville,
      required this.pays,
      required this.dateNaissance,
      required this.civilite,
      required this.langue,
      required this.origine,
      required this.hasPremium});
  factory Profile.fromJson(_) {
    return Profile(
        //userId: int.parse(_['id'].toString()),
        phone: _['phone'].toString(),
        nom: _['nom'].toString(),
        prenom: _['prenom'].toString(),
        sexe: _['sexe'].toString(),
        typeChretien: _['typeChretien'].toString(),
        photoProfil: _['profil'].toString(),
        ville: _['ville'].toString(),
        pays: _['pays'].toString(),
        dateNaissance: _['naissance'].toString(),
        civilite: _['civilite'].toString(),
        langue: _['langue'].toString(),
        origine: _['origine'].toString(),
        hasPremium: bool.fromEnvironment(_['premium'].toString()));
  }
  final String nom;
  final String prenom;
  final String sexe;
  final String typeChretien;
  final String photoProfil;
  final String ville;
  final String pays;
  final String dateNaissance;
  final String civilite;
  final String origine;
  final String langue;
  final bool hasPremium;
  //final int userId;
  final String phone;
  Map<String, dynamic> tojson() => {
        'nom': nom,
        'prenom': prenom,
        'sexe': sexe,
        'typeChretien': typeChretien,
        'photoProfil': photoProfil,
        'ville': ville,
        'pays': pays,
        'dateNaissance': dateNaissance,
        'civilite': civilite,
        'origine': origine,
        'langue': langue
      };
}
