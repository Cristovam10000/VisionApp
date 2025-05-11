import 'package:flutter/material.dart';

class ResultadoPage extends StatelessWidget {
  final Map<String, dynamic> resultado;

  const ResultadoPage({super.key, required this.resultado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado da Análise')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: resultado.entries.map((entry) {
            return ListTile(
              title: Text(entry.key),
              subtitle: Text(entry.value.toString()),
            );
          }).toList(),
        ),
      ),
    );
  }
}