import 'package:flutter/material.dart';
import 'package:vision_app/presentation/widgets/state/state.dart';

class Logincontainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      // Centraliza o Container na tela
      child: Container(
        width: 300, // Define uma largura fixa para o Container
        decoration: BoxDecoration(
          // Fundo branco para contraste
          color: Colors.white,
          borderRadius: BorderRadius.circular(12), // Bordas arredondadas
          border: Border.all(
            color: Colors.grey, // Borda cinza
            width: 1, // Largura da borda
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ajusta o tamanho ao conteúdo
            children: <Widget>[
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Digite seu CPF', // Texto do campo de entrada
                  border: OutlineInputBorder(), // Adiciona borda ao campo
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                obscureText: true, // Oculta o texto (senha)
                decoration: InputDecoration(
                  labelText: 'Digite sua senha', // Texto do campo de entrada
                  border: OutlineInputBorder(), // Adiciona borda ao campo
                ),
              ),
              const SizedBox(height: 20),
              Button(
                text: 'Entrar',
                onPressed: () {
                  print('Botão Entrar pressionado');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
