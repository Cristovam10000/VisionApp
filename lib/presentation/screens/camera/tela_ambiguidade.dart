import 'package:flutter/material.dart';
import 'package:vision_app/presentation/screens/home/tela_home.dart';
import 'package:vision_app/presentation/screens/buscacpf/ficha_result_tela.dart';

class AmbiguityPage extends StatelessWidget {
  final Map<String, dynamic> perfil;
  final List<dynamic> opcoes;

  const AmbiguityPage({super.key, required this.opcoes, required this.perfil});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 11, 16, 24),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => TelaHome(perfil: perfil)),
              (Route<dynamic> route) => false,
            );
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Título reposicionado manualmente
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Pessoas\nEncontradas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 28,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Lista com rolagem
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: opcoes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final opcao = opcoes[index];
                  final identidade = opcao['identidade'];

                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF13273D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          identidade['url_face'] ??
                              'https://via.placeholder.com/150',
                        ),
                        radius: 25,
                      ),
                      title: Text(
                        identidade['nome'] ?? 'Sem nome',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
                                    'vulgo':
                                        opcao['ficha_criminal']['ficha_criminal']['vulgo'],
                                    'crimes':
                                        opcao['crimes'], // ou opcao['ficha_criminal']['crimes']
                                  },
                                  perfil: perfil,
                                  fromAmbiguity: true,
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
