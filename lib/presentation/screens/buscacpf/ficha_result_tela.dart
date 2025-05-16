import 'package:flutter/material.dart';

class FichaResultPage extends StatelessWidget {
  final Map<String, dynamic> ficha;

  const FichaResultPage({super.key, required this.ficha});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Fundo escuro
      appBar: AppBar(
        title: const Text('Resultado da Ficha'),
        backgroundColor: const Color(0xFF1E1E1E), // Cor do AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            ficha.isEmpty
                ? const Center(
                  child: Text(
                    'Nenhuma informação encontrada.',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
                : ListView(
                  children: [
                    // Foto e Nome
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              ficha['foto_url'] != null
                                  ? NetworkImage(
                                    ficha['foto_url'],
                                  ) // Carrega a imagem da URL
                                  : const NetworkImage(
                                        'https://media.istockphoto.com/id/1495088043/pt/vetorial/user-profile-icon-avatar-or-person-icon-profile-picture-portrait-symbol-default-portrait.jpg?s=170667a&w=0&k=20&c=ESgi5k6Bptg59QPXfAzQiWHtNhvMrUVn07x3wM6E4RU=',
                                      )
                                      as ImageProvider,

                          /// Substitua pela imagem do perfil
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ficha['nome'] ?? 'Nome não encontrado',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ficha['vulgo'] ?? 'Nenhum vulgo',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Informações Pessoais
                    Text(
                      'CPF: ${ficha['cpf'] ?? 'Não informado'}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Data de Nascimento: ${ficha['data_nascimento'] ?? 'Não informado'}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nome da Mãe: ${ficha['nome_mae'] ?? 'Não informado'}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nome do Pai: ${ficha['nome_pai'] ?? 'Não informado'}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 24),

                    // Resumo Criminal
                    const Text(
                      'Resumo Criminal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Lista de Crimes
                    if (ficha['crimes'] != null)
                      ...List.generate((ficha['crimes'] as List).length, (
                        index,
                      ) {
                        final crime = ficha['crimes'][index];
                        return CrimeCard(crime: crime);
                      }),
                  ],
                ),
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
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  crime['nome_crime'] ?? 'Crime não informado',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
                            ? Colors
                                .green // Verde para "Em Aberto"
                            : crime['status'] == 'Foragido'
                            ? Colors
                                .red // Vermelho para "Foragido"
                            : Colors.grey, // Cinza para outros casos
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    crime['status'] ?? 'Status desconhecido',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Artigo: ${crime['artigo'] ?? 'Não informado'}',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Descrição: ${crime['descricao'] ?? 'Não informado'}',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Local: ${crime['cidade'] ?? 'Cidade não informada'}, ${crime['estado'] ?? 'Estado não informado'}',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
