import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_texts.dart';

// Seu primeiro widget personalizado: TelaHome
class TelaHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Home'),
      ),
      body: Center(
        child: Text(
          'Bem-vindo à Tela Home!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
