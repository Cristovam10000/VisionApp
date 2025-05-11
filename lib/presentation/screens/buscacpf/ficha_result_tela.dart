import 'package:flutter/material.dart';

class FichaResultPage extends StatelessWidget {
  final Map<String, dynamic> ficha;

  const FichaResultPage({super.key, required this.ficha});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resultado da Ficha')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ficha.isEmpty
            ? Text('Nenhuma informação encontrada.')
            : ListView(
                children: ficha.entries.map((entry) {
                  return ListTile(
                    title: Text('${entry.key}'),
                    subtitle: Text('${entry.value}'),
                  );
                }).toList(),
              ),
      ),
    );
  }
}