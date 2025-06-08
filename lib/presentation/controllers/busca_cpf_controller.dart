import 'package:flutter/material.dart';
import 'package:vision_app/core/services/upload_service.dart';
import 'package:vision_app/presentation/pages/camera/popup_dialog_nada_consta.dart';
import 'package:vision_app/presentation/pages/home/tela_home.dart';
import 'package:vision_app/presentation/pages/resultados/ficha_result_tela.dart';
import 'package:vision_app/presentation/widgets/loading_dialog.dart';

mixin BuscaCpfController<T extends StatefulWidget> on State<T> {
  final _uploadService = UploadService();

  Future<void> buscarFicha({
    required BuildContext context,
    required TextEditingController cpfCtrl,
    required String token,
    required Map<String, dynamic>? perfil,
    required void Function(String?) setCpfError,
  }) async {
    final cpf = cpfCtrl.text.trim();

    setCpfError(null);

    if (cpf.isEmpty) {
      setCpfError('Por favor, digite um CPF');
      return;
    }

    if (cpf.length != 11) {
      setCpfError('CPF deve ter 11 dígitos');
      return;
    }

    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token ausente. Faça login novamente.')),
      );
      return;
    }

    showLoadingDialog(context, mensagem: 'Buscando ficha...');

    try {
      final ficha = await _uploadService.buscarFichaPorCpf(
        cpf,
        perfil?['matricula'],
        token,
      );
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => FichaResultPage(
            ficha: ficha,
            perfil: perfil,
            token: token,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);

        await showNadaConstaDialog(context);

        if (mounted) {
          FocusScope.of(context).unfocus();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => TelaHome(perfil: perfil),
            ),
            (Route<dynamic> route) => false,
          );
        }
      }
    }
  }
}