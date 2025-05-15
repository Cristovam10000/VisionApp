import 'package:flutter/material.dart';
import 'package:vision_app/presentation/screens/home/tela_home.dart';
import 'package:vision_app/presentation/widgets/state/state.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import '../../../services/auth_firebase.dart';
import '../../../services/auth_backend.dart';
import '../../../services/auth_token_service.dart';
import 'package:vision_app/presentation/screens/login/popUp_cadastro.dart';
import 'package:flutter/gestures.dart';

class Logincontainer extends StatefulWidget {
  @override
  _LogincontainerState createState() => _LogincontainerState();
}

class _LogincontainerState extends State<Logincontainer> {
  bool _obscurePassword = true; // controla a visibilidade da senha

  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  String? _mensagemErroCpf; // Mensagem de erro para CPF
  String? _mensagemErroSenha; // Mensagem de erro para senha

  void _fazerLogin() async {
    final cpf = emailController.text.trim(); // Agora isso é o CPF
    final senha = senhaController.text;

    setState(() {
      _mensagemErroCpf = null; // Limpa mensagens de erro anteriores
      _mensagemErroSenha = null;
    });

    if (cpf.isEmpty) {
      setState(() {
        _mensagemErroCpf = 'O CPF não pode estar vazio.';
      });
      return;
    }

    if (senha.isEmpty) {
      setState(() {
        _mensagemErroSenha = 'A senha não pode estar vazia.';
      });
      return;
    }

    final emailFake = '$cpf@app.com'; // Converte CPF para e-mail

    // 1) Login no Firebase → ID token
    final firebaseToken = await AuthService().loginComFirebase(
      emailFake,
      senha,
    );
    if (firebaseToken == null) {
      setState(() {
        _mensagemErroCpf = 'CPF ou senha incorretos.';
        _mensagemErroSenha = 'CPF ou senha incorretos.';
      });
      return;
    }

    // 2) Envia o Firebase token pro FastAPI → JWT próprio
    final backendJwt = await postWithToken(firebaseToken);
    if (backendJwt == null) {
      setState(() {
        _mensagemErroCpf = 'Erro ao autenticar com o servidor.';
      });
      return;
    }

    // 3) Usa o JWT do seu back-end pra puxar o perfil
    final perfil = await getUserProfile(backendJwt);
    if (perfil == null) {
      setState(() {
        _mensagemErroCpf = 'Não foi possível obter o perfil.';
      });
      return;
    }

    // 4) Sucesso: atualiza UI
    setState(() {
      _mensagemErroCpf = null;
      _mensagemErroSenha = null;
    });

    await AuthTokenService().saveToken(backendJwt);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder:
            (context) => TelaHome(perfil: perfil), // Passa o Map diretamente
      ),
      (Route<dynamic> route) => false, // Remove todas as rotas anteriores
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
        border: Border.all(color: ColorPalette.cinzaClaro, width: 1),
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
                color: ColorPalette.preto,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              controller: emailController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Digite seu CPF',
                border: const OutlineInputBorder(),
                errorText: _mensagemErroCpf, // Exibe a mensagem de erro
              ),
            ),
            const SizedBox(height: 20),

            // CAMPO DE SENHA COM ÍCONE DE OLHO
            TextField(
              style: const TextStyle(
                color: ColorPalette.preto,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              obscureText: _obscurePassword,
              controller: senhaController,
              decoration: InputDecoration(
                labelText: 'Digite sua senha',
                border: const OutlineInputBorder(),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(
                    right: 17.0, top: 10, bottom: 12
                  ), // Adiciona espaçamento à direita
                  child: IconButton(
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
                errorText: _mensagemErroSenha, // Exibe a mensagem de erro
              ),
            ),
            const SizedBox(height: 20),
            Button(text: 'Entrar', onPressed: _fazerLogin),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Não possui uma conta ? ',
                    style: const TextStyle(
                      color: ColorPalette.cinzaMedio,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Montserrat',
                    ),
                    children: [
                      TextSpan(
                        text: 'Cadastrar',
                        style: const TextStyle(
                          color: ColorPalette.button,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Montserrat',
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TelaCadastro(),
                                  ),
                                );
                              },
                      ),
                    ],
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
