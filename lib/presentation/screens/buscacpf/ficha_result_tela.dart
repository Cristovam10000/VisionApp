import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vision_app/presentation/screens/buscacpf/image_popup.dart';
import 'package:vision_app/presentation/screens/home/tela_home.dart';

class FichaResultPage extends StatelessWidget {
  final Map<String, dynamic> ficha;
  final Map<String, dynamic> perfil;

  const FichaResultPage({super.key, required this.ficha, required this.perfil});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.dark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        TelaHome(perfil: perfil), // Passa o Map diretamente
              ),
              (Route<dynamic> route) =>
                  false, // Remove todas as rotas anteriores
            );
          },
        ),
      ),

      body:
          ficha.isEmpty
              ? const Center(
                child: Text(
                  'Nenhuma informação encontrada.',
                  style: TextStyle(color: Colors.white),
                ),
              )
              : ListView(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 40,
                  right: 37,
                  bottom: 24,
                ),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Container 1: Foto, Nome, Vulgo
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: ColorPalette.dark,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => ImagePopup(
                                        imageUrl:
                                            ficha['foto_url'] ??
                                            'https://i.imgur.com/j6xgQ7D.png',
                                      ),
                                );
                              },
                              child: CircleAvatar(
                                radius: 75,
                                backgroundImage: NetworkImage(
                                  ficha['foto_url'] ??
                                      'https://i.imgur.com/j6xgQ7D.png',
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        ficha['nome'] ?? 'Nome não encontrado',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/Iconperson.svg',
                                  width: 20,
                                  height: 20,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  ficha['vulgo'] ?? 'Nenhum vulgo',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 1),

                      // Container 2: CPF, Data de Nascimento, Nome da Mãe, Nome do Pai
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: ColorPalette.dark,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'CPF: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 19,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ficha['cpf'] ?? 'Não informado',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Data de Nascimento: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 19,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ficha['data_nascimento'] ??
                                        'Não informado',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Nome da Mãe: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 19,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ficha['nome_mae'] ?? 'Não informado',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Nome do Pai: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 19,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ficha['nome_pai'] ?? 'Não informado',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        'Resumo Criminal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 18),

                      if (ficha['crimes'] != null)
                        ...List.generate(
                          ficha['crimes'].length,
                          (index) => CrimeCard(crime: ficha['crimes'][index]),
                        ),
                    ],
                  ),
                ],
              ),
    );
  }

  Widget infoLine(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        '$label: ${value ?? 'Não informado'}',
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}

class CrimeCard extends StatelessWidget {
  final Map<String, dynamic> crime;

  const CrimeCard({super.key, required this.crime});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(19, 39, 61, 1),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mandato',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        crime['status'] == 'Em Aberto'
                            ? ColorPalette.vermelhoPaleta
                            : Colors.grey,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    crime['status'] ?? 'Desconhecido',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Data: ${crime['data_ocorrencia'] ?? 'Não informada'}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              'Artigo: ${crime['artigo'] ?? 'Não informado'}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${crime['cidade'] ?? ''}, ${crime['estado'] ?? ''}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
