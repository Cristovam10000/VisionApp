// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:vision_app/presentation/screens/home/tela_home.dart';
import 'package:vision_app/presentation/widgets/state/loading_dialog.dart';
import 'package:vision_app/presentation/widgets/state/state.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:vision_app/services/local_storage_service.dart';
import '../../../services/auth_firebase_service.dart';
import '../../../services/auth_backend_service.dart';
import '../../../services/auth_token_service.dart';

class Logincontainer extends StatefulWidget {
  const Logincontainer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LogincontainerState createState() => _LogincontainerState();
}

class _LogincontainerState extends State<Logincontainer> {
  bool _obscurePassword = true; // controla a visibilidade da senha

  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  String? _mensagemErroCpf; // Mensagem de erro para CPF
  String? _mensagemErroSenha; // Mensagem de erro para senha

void _fazerLogin() async {
    showLoadingDialog(context, mensagem: 'Entrando...');

    final cpf = emailController.text.trim();
    final senha = senhaController.text;
    final emailFake = '$cpf@app.com';

    setState(() {
      _mensagemErroCpf = null;
      _mensagemErroSenha = null;
    });

    if (cpf.isEmpty && senha.isEmpty) {
      Navigator.pop(context); // Fecha o loading antes de sair
      setState(() {
        _mensagemErroCpf = 'O CPF estar vazio.';
        _mensagemErroSenha = 'O Senha estar vazio.';
      });
      return;
    }

    else if (cpf.isEmpty) {
      Navigator.pop(context); // Fecha o loading antes de sair
      setState(() {
        _mensagemErroCpf = 'O CPF estar vazio.';
      });
      return;
    }


    else if (senha.isEmpty) {
      Navigator.pop(context); // Fecha o loading antes de sair
      setState(() {
        _mensagemErroSenha = 'O Senha estar vazio.';
      });
      return;
    }



    try {
      final firebaseToken = await AuthService().loginComFirebase(emailFake, senha);
      if (firebaseToken == null) {
        Navigator.pop(context);
        setState(() {
          _mensagemErroCpf = 'CPF pode está icorreto';
          _mensagemErroSenha = 'Senha pode está incorreta';
        });
        return;
      }

      final backendJwt = await postWithToken(firebaseToken);
      if (backendJwt == null) {
        Navigator.pop(context);
        setState(() {
          _mensagemErroCpf = 'Erro ao autenticar com o servidor.';
        });
        return;
      }

      final perfil = await getUserProfile(backendJwt);
      if (perfil == null) {
        Navigator.pop(context);
        setState(() {
          _mensagemErroCpf = 'Não foi possível obter o perfil.';
        });
        return;
      }

      await AuthTokenService().saveToken(backendJwt);

      await LocalStorageService().saveLoginData(backendJwt, cpf);


      Navigator.pop(context); // Fecha o loading antes de navegar

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => TelaHome(perfil: perfil)),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      Navigator.pop(context); // Fecha o loading em caso de erro inesperado

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login: $e')),
      );
    }
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
            TextField(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              controller: emailController, // Isso causa o problema
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Digite seu CPF',
                border: const OutlineInputBorder(),
                errorText: _mensagemErroCpf
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
              controller: senhaController,
              decoration: InputDecoration(
                labelText: 'Digite sua senha',
                border: const OutlineInputBorder(),
                errorText: _mensagemErroSenha,
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
            Button(text: 'Entrar', onPressed: _fazerLogin),
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
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
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
                                    const SizedBox(height: 16),
                                    // Título
                                    const Text(
                                      'Não tem cadastro?',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    // Mensagem
                                    const Text(
                                      'Entre em contato com um superior para liberar seu acesso ao VisionApp.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 24),
                                    // Botão
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorPalette.button,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 12,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pop(); // Fecha o popup
                                      },
                                      child: const Text(
                                        'Entendido',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
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
