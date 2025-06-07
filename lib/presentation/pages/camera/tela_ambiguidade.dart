import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:vision_app/presentation/pages/camera/popup_dialog_ambiguidade.dart';
import 'package:vision_app/presentation/pages/home/tela_home.dart';
import 'package:vision_app/presentation/pages/resultados/ficha_result_tela.dart';
import 'package:vision_app/presentation/widgets/state/navbar.dart'; // Certifique-se de importar isso
import 'package:google_fonts/google_fonts.dart';
import 'package:vision_app/presentation/widgets/state/formatacao.dart';

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
      showAmbiguousFaceDialog(context, token: widget.token);
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
          icon: const Icon(Icons.arrow_back_ios, color: ColorPalette.branco),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 58.0, vertical: 0),
              child: Text(
                'Pessoas\nEncontradas',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: ColorPalette.branco,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                itemCount: widget.opcoes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final opcao = widget.opcoes[index];
                  final identidade = opcao['identidade'];

                  return Container(
                    decoration: BoxDecoration(
                      color: ColorPalette.azulMarinho,
                      borderRadius: BorderRadius.circular(16),
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
                        radius: 20,
                      ),
                      title: Text(
                        formatCpf(identidade['cpf']) ?? 'Sem cpf',
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