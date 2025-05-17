import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:vision_app/presentation/screens/home/tela_home.dart';
import 'package:vision_app/presentation/screens/buscacpf/ficha_result_tela.dart';

class AmbiguityPage extends StatelessWidget {
  final List<dynamic> opcoes;

  const AmbiguityPage({Key? key, required this.opcoes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.dark,
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Pessoas Encontradas',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 26,
                ),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Volta diretamente para a TelaHome
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder:
                    (context) => TelaHome(
                      perfil: {},
                    ), // Passe o perfil aqui, se necessário
              ),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: opcoes.length,
        itemBuilder: (context, index) {
          final opcao = opcoes[index];
          final identidade = opcao['identidade'];

          return Card(
            color: Color.fromRGBO(19, 39, 61, 1), // Defina a cor desejada
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  identidade['url_face'] ?? 'https://via.placeholder.com/150',
                ),
                radius: 20,
              ),
              title: Text(
                identidade['cpf'] ?? 'CPF não disponível',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => FichaResultPage(
                          ficha: {
                            'cpf': opcao['identidade']['cpf'],
                            'nome': opcao['identidade']['nome'],
                            'nome_mae': opcao['identidade']['nome_mae'],
                            'nome_pai': opcao['identidade']['nome_pai'],
                            'data_nascimento':
                                opcao['identidade']['data_nascimento'],
                            'foto_url': opcao['identidade']['url_face'],
                            'vulgo': opcao['ficha_criminal']['vulgo'],
                            'crimes': opcao['crimes'],
                          },
                          perfil: {}, // Passe o perfil aqui, se necessário
                          fromAmbiguity: true,
                        ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
