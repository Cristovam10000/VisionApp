class UserProfile {
  final String nomeCompleto;
  final String cargo;
  final String classe;
  final String matricula;

  UserProfile({
    required this.nomeCompleto,
    required this.cargo,
    required this.classe,
    required this.matricula,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nomeCompleto: json['nomeCompleto'] as String? ?? '',
      cargo: json['cargo'] as String? ?? '',
      classe: json['classe'] as String? ?? '',
      matricula: json['matricula'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomeCompleto': nomeCompleto,
      'cargo': cargo,
      'classe': classe,
      'matricula': matricula,
    };
  }
}