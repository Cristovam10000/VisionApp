import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/backend_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  String? _mensagem;

void _fazerLogin() async {
  final email = emailController.text.trim();
  final senha = senhaController.text;

  final firebaseToken = await AuthService().loginComFirebase(email, senha);

  if (firebaseToken != null) {
    // Enviando para o backend e recebendo o JWT da API
    final jwt = await autenticarComBackend(firebaseToken);

    if (jwt != null) {
      setState(() {
        _mensagem = 'Login com sucesso! JWT: $jwt';
      });
    } else {
      setState(() {
        _mensagem = 'Falha na autenticação com o back-end.';
      });
    }
  } else {
    setState(() {
      _mensagem = 'Erro ao fazer login no Firebase.';
    });
  }
}

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Firebase + Backend')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: senhaController, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _fazerLogin, child: const Text('Login')),
            const SizedBox(height: 20),
            if (_mensagem != null) Text(_mensagem!, style: const TextStyle(color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
