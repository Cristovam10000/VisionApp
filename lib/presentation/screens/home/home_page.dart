import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Map<String, dynamic> perfil;
  
  const HomePage({super.key, required this.perfil});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bem-vindo, ${perfil['nome']}!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/camera'),
              child: Text('Abrir Câmera'),
            ),
          ],
        ),
      ),
    );
  }
}