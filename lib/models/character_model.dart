class CharacterModel {
  final String name;
  final String gender;
  final String height;
  final String mass;
  final String birthYear;

  CharacterModel({
    required this.name,
    required this.gender,
    required this.height,
    required this.mass,
    required this.birthYear,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      name: json['name'],
      gender: json['gender'],
      height: json['height'],
      mass: json['mass'],
      birthYear: json['birth_year'],
    );
  }
}
