// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vision_app/presentation/widgets/button.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import '../../controllers/fazer_login_controller.dart';

class Logincontainer extends StatefulWidget {
  const Logincontainer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LogincontainerState createState() => _LogincontainerState();
}

class _LogincontainerState extends State<Logincontainer> {
  bool _obscurePassword = true;
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  String? _mensagemErroCpf;
  String? _mensagemErroSenha;

  void _setError(String? cpfError, String? senhaError) {
    setState(() {
      _mensagemErroCpf = cpfError;
      _mensagemErroSenha = senhaError;
    });
  }

  void _fazerLogin() {
    fazerLogin(
      context: context,
      emailController: emailController,
      senhaController: senhaController,
      setError: _setError,
    );
  }

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
        border: Border.all(color: ColorPalette.cinza, width: 1),
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
            SizedBox(
              width: 326,
              child: TextField(
                style: Theme.of(context).textTheme.bodyMedium,
                controller: emailController, // Isso causa o problema
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(
                    11,
                  ), // por exemplo, limite 11 caracteres
                ],
                decoration: InputDecoration(
                  labelText: 'Digite seu CPF',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorText: _mensagemErroCpf,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // CAMPO DE SENHA COM ÍCONE DE OLHO
            SizedBox(
              width: 326,
              child: TextField(
                style: Theme.of(context).textTheme.bodyMedium,
                obscureText: _obscurePassword,
                controller: senhaController,
                decoration: InputDecoration(
                  labelText: 'Digite sua senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorText: _mensagemErroSenha,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
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
            ),

            const SizedBox(height: 20),
            Button(text: 'Entrar', onPressed: _fazerLogin),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 0,
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
                    showDialog(
                      context: context,
                      barrierColor:
                          Colors.transparent, // Deixa o fundo transparente
                      builder: (BuildContext context) {
                        return Stack(
                          children: [
                            // Fundo com o papel de parede
                            Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/logo.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Popup centralizado
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorPalette.branco,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorPalette.preto,
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Ícone no topo
                                    const Image(
                                      image: AssetImage('assets/IconApp.png'),
                                    ),
                                    const SizedBox(height: 12),
                                    // Título
                                    Text(
                                      'Não tem cadastro?',
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 25),
                                    // Mensagem
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0,
                                      ),
                                      child: const Text(
                                        'Entre em contato com um superior para liberar seu acesso ao VisionApp.',
                                        style: TextStyle(
                                          wordSpacing: 0,
                                          letterSpacing: 0,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: ColorPalette.preto,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    // Botão
                                    Button(
                                      text: 'Entendido',
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pop(); // Fecha o popup
                                      },
                                    ),
                                    
                                    const SizedBox(height: 60),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
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
