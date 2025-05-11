import 'package:flutter/material.dart';
import 'package:vision_app/presentation/screens/home/tela_home.dart';
import 'package:vision_app/presentation/widgets/state/state.dart';
import 'package:vision_app/core/constants/app_colors.dart';

class Logincontainer extends StatefulWidget {
  @override
  _LogincontainerState createState() => _LogincontainerState();
}

class _LogincontainerState extends State<Logincontainer> {
  bool _obscurePassword = true; // controla a visibilidade da senha

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorPalette.branco,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 42,
          right: 24,
          left: 25,
          bottom: 64,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const TextField(
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                labelText: 'Digite seu CPF',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // CAMPO DE SENHA COM ÍCONE DE OLHO
            TextField(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Digite sua senha',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: ColorPalette.preto,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),
            Button(
              text: 'Entrar',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaHome()),
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Não possui uma conta?',
                  style: TextStyle(
                    color: ColorPalette.cinzaMedio,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 0),
                TextButton(
                  onPressed: () {
                    print('Cadastrar');
                  },
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(
                      color: ColorPalette.button,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
