class FichaModel {
  final String? cpf;
  final String? nome;
  final String? nomeMae;
  final String? nomePai;
  final String? dataNascimento;
  final String? fotoUrl;
  final String? vulgo;
  final List<dynamic>? crimes;

  FichaModel({
    this.cpf,
    this.nome,
    this.nomeMae,
    this.nomePai,
    this.dataNascimento,
    this.fotoUrl,
    this.vulgo,
    this.crimes = const [],
  });

  // Para resposta do reconhecimento facial
  factory FichaModel.fromFacial(Map<dynamic, dynamic>? identidade, Map<String, dynamic>? fichaCriminal) {
    final fichaInfo = fichaCriminal?['ficha_criminal'] ?? {};
    return FichaModel(
      cpf: identidade?['cpf'],
      nome: identidade?['nome'],
      nomeMae: identidade?['nome_mae'],
      nomePai: identidade?['nome_pai'],
      dataNascimento: identidade?['data_nascimento'],
      fotoUrl: identidade?['url_face'],
      vulgo: fichaInfo['vulgo'],
      crimes: fichaCriminal?['crimes'] ?? [],
    );
  }

  // Para resposta da busca por CPF
  factory FichaModel.fromCpf(Map<dynamic, dynamic>? json) {
    final fichaCriminal = json?['ficha_criminal'] ?? {};
    return FichaModel(
      cpf: json?['cpf'],
      nome: json?['nome'],
      nomeMae: json?['nome_mae'],
      nomePai: json?['nome_pai'],
      dataNascimento: json?['data_nascimento'],
      fotoUrl: json?['foto_url'],
      vulgo: fichaCriminal['vulgo'],
      crimes: json?['crimes'] ?? [],
    );
  }

  Map<String, dynamic>? toMap() => {
    'cpf': cpf,
    'nome': nome,
    'nome_mae': nomeMae,
    'nome_pai': nomePai,
    'data_nascimento': dataNascimento,
    'foto_url': fotoUrl,
    'vulgo': vulgo,
    'crimes': crimes,
  };
}