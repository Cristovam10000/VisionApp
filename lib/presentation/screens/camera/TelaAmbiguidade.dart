import 'package:flutter/material.dart';

class AmbiguityPage extends StatelessWidget {
  final List<dynamic> opcoes;

  const AmbiguityPage({Key? key, required this.opcoes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pessoas Encontradas'),
      ),
      body: ListView.builder(
        itemCount: opcoes.length,
        itemBuilder: (context, index) {
          final opcao = opcoes[index];
          return Card(
            color: Colors.blue[900],
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  opcao['foto_url'] ?? 'https://via.placeholder.com/150',
                ),
                radius: 20,
              ),
              title: Text(
                opcao['nome'] ?? 'Nome não disponível',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                opcao['cpf'] ?? 'CPF não disponível',
                style: TextStyle(
                  color: Colors.grey[300],
                ),
              ),
              onTap: () {
                Navigator.pop(context, opcao); // Retorna a opção selecionada
              },
            ),
          );
        },
      ),
    );
  }
}