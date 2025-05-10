import 'package:flutter/material.dart';
import 'package:vision_app/presentation/screens/home/tela_home.dart';
import 'package:vision_app/presentation/widgets/state/state.dart';
import 'package:vision_app/core/constants/app_colors.dart';

class Logincontainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      // Centraliza o Container na tela
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16), // Bordas arredondadas
          border: Border.all(
            color: Colors.grey, // Borda cinza
            width: 1, // Largura da borda
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 42, // Espaçamento superior
            right: 24, // Espaçamento à direita
            left: 25, // Espaçamento à esquerda
            bottom: 64, // Espaçamento inferior
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ajusta o tamanho ao conteúdo
            children: <Widget>[
              const TextField(
                style: TextStyle(
                  color: Colors.black, // Cor preta para o texto digitado
                  fontSize: 16, // Tamanho da fonte
                  fontWeight: FontWeight.w400, // Peso da fonte
                ),
                decoration: InputDecoration(
                  labelText: 'Digite seu CPF', // Texto do campo de entrada
                  border: OutlineInputBorder(), // Adiciona borda ao campo
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                style: TextStyle(
                  color: Colors.black, // Cor preta para o texto digitado
                  fontSize: 16, // Tamanho da fonte
                  fontWeight: FontWeight.w400, // Peso da fonte
                ),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TelaHome(), // Navega para a tela de login
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centraliza os itens na linha
                children: [
                  Text(
                    'Não possui uma conta ?',
                    style: const TextStyle(
                      color: ColorPalette.cinzaMedio, // Cor cinza médio
                      fontSize: 14, // Tamanho da fonte
                      fontWeight: FontWeight.w400, // Peso da fonte
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Ação para "Cadastrar"
                      print('Cadastrar');
                    },
                    child: Text(
                      'Cadastrar',
                      style: const TextStyle(
                        color: ColorPalette.button, // Cor destacada (laranja)
                        fontSize: 14, // Tamanho da fonte
                        fontWeight: FontWeight.w700, // Peso da fonte (negrito)
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}