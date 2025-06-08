import 'package:flutter/material.dart';
import 'package:vision_app/data/model/usermodel.dart';
import 'package:vision_app/presentation/pages/home/tela_home.dart';
import 'package:vision_app/presentation/widgets/loading_dialog.dart';
import 'package:vision_app/core/services/local_storage_service.dart';
import '../../core/services/auth_firebase_service.dart';
import '../../core/services/auth_backend_service.dart';
import '../../core/services/auth_token_service.dart';

Future<void> fazerLogin({
  required BuildContext context,
  required TextEditingController emailController,
  required TextEditingController senhaController,
  required void Function(String? cpfError, String? senhaError) setError,
}) async {
  showLoadingDialog(context, mensagem: 'Entrando...');

  final cpf = emailController.text.trim();
  final senha = senhaController.text;
  final emailFake = '$cpf@app.com';

  setError(null, null);

  if (cpf.isEmpty && senha.isEmpty) {
    Navigator.pop(context);
    setError('O CPF estar vazio.', 'O Senha estar vazio.');
    return;
  } else if (cpf.isEmpty) {
    Navigator.pop(context);
    setError('O CPF estar vazio.', null);
    return;
  } else if (senha.isEmpty && cpf.length != 11) {
    Navigator.pop(context);
    setError('CPF deve ter 11 dígitos', 'O Senha estar vazio.');
    return;
  }

  if (cpf.length != 11) {
    Navigator.pop(context);
    setError('CPF deve ter 11 dígitos', null);
    return;
  } else if (senha.isEmpty) {
    Navigator.pop(context);
    setError(null, 'O Senha estar vazio.');
    return;
  }

  try {
    final firebaseToken = await AuthService().loginComFirebase(
      emailFake,
      senha,
    );
    if (firebaseToken == null) {
      Navigator.pop(context);
      setError('CPF pode está incorreto', 'Senha pode está incorreta');
      return;
    }

    final backendJwt = await postWithToken(firebaseToken);
    if (backendJwt == null) {
      Navigator.pop(context);
      setError('Erro ao autenticar com o servidor.', null);
      return;
    }

    final perfilMap = await getUserProfile(backendJwt);
    if (perfilMap == null) {
      Navigator.pop(context);
      setError('Não foi possível obter o perfil.', null);
      return;
    }

    final userProfile = UserProfile.fromJson(perfilMap);

    await AuthTokenService().saveToken(backendJwt);
    await LocalStorageService().saveLoginData(backendJwt);

    Navigator.pop(context);

    FocusScope.of(context).unfocus();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => TelaHome(perfil: perfilMap)),
      (Route<dynamic> route) => false,
    );

  } catch (e) {
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Erro ao fazer login: $e')));
  }
}
