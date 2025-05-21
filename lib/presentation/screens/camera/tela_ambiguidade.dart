import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:vision_app/presentation/screens/buscacpf/tela_busca_cpf.dart';
import 'package:vision_app/presentation/screens/camera/popup_dialog_ambiguidade.dart';
import 'package:vision_app/presentation/screens/home/tela_home.dart';
import 'package:vision_app/presentation/screens/resultados/ficha_result_tela.dart';
import 'package:vision_app/presentation/widgets/state/navbar.dart'; // Certifique-se de importar isso

class AmbiguityPage extends StatefulWidget {
  final Map<String, dynamic>? perfil;
  final List<dynamic> opcoes;
  final String token;

  const AmbiguityPage({
    super.key,
    required this.opcoes,
    this.perfil,
    required this.token,
  });

  @override
  State<AmbiguityPage> createState() => _AmbiguityPageState();
}

class _AmbiguityPageState extends State<AmbiguityPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAmbiguousFaceDialog(context, token: widget.token,);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.dark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorPalette.branco),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => TelaHome(perfil: widget.perfil),
              ),
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
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Pessoas\nEncontradas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.branco,
                  fontSize: 28,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: widget.opcoes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final opcao = widget.opcoes[index];
                  final identidade = opcao['identidade'];

                  return Container(
                    decoration: BoxDecoration(
                      color: ColorPalette.azulMarinho,
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
                          color: ColorPalette.branco,
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
                                    'cpf': identidade['cpf'],
                                    'nome': identidade['nome'],
                                    'nome_mae': identidade['nome_mae'],
                                    'nome_pai': identidade['nome_pai'],
                                    'data_nascimento':
                                        identidade['data_nascimento'],
                                    'foto_url': identidade['url_face'],
                                    'vulgo':
                                        opcao['ficha_criminal']['ficha_criminal']['vulgo'],
                                    'crimes': opcao['crimes'],
                                  },
                                  perfil: widget.perfil,
                                  fromAmbiguity: true,
                                  token: widget.token,
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
      bottomNavigationBar: CustomNavbar(
        currentIndex: -1, // Mantém desativado
        perfil: widget.perfil,
        token: widget.token,
      ),
    );
  }
}
