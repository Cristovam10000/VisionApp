import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FichaResultPage extends StatelessWidget {
  final Map<String, dynamic> ficha;

  const FichaResultPage({super.key, required this.ficha});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.dark,
      appBar: AppBar(backgroundColor: ColorPalette.dark),
      body:
          ficha.isEmpty
              ? const Center(
                child: Text(
                  'Nenhuma informação encontrada.',
                  style: TextStyle(color: Colors.white),
                ),
              )
              : ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundImage: NetworkImage(
                          ficha['foto_url'] ??
                              'https://i.imgur.com/j6xgQ7D.png',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        ficha['nome'] ?? 'Nome não encontrado',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        ficha['vulgo'] ?? 'Vulgo não encontrado',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      SvgPicture.asset(
                        'assets/Iconperson.svg', // Substitua pelo caminho correto do arquivo SVG
                        width: 20,
                        height: 20,
                        color: Colors.white70, // Aplica uma tonalidade branca
                      ),
                      const SizedBox(height: 24),
                      infoLine('CPF', ficha['cpf']),
                      infoLine('Data de Nascimento', ficha['data_nascimento']),
                      infoLine('Nome da Mãe', ficha['nome_mae']),
                      infoLine('Nome do Pai', ficha['nome_pai']),
                      const SizedBox(height: 24),
                      const Text(
                        'Resumo Criminal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
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
              'Data: ${crime['data'] ?? 'Não informada'}',
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
