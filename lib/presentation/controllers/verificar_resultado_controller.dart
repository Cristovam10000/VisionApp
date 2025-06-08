import 'package:flutter/material.dart';
import 'package:vision_app/presentation/pages/resultados/ficha_result_tela.dart';
import 'package:vision_app/presentation/pages/camera/face_camera_page.dart';
import 'package:vision_app/presentation/pages/camera/popup_dialog_error_foto.dart';
import 'package:vision_app/presentation/pages/camera/popup_dialog_nada_consta.dart';
import 'package:vision_app/presentation/pages/camera/tela_ambiguidade.dart';
import 'package:vision_app/presentation/pages/home/tela_home.dart';

Future<void> verificarResultado({
  required BuildContext context,
  required Map<String, dynamic>? resultado,
  required Map<String, dynamic>? perfil,
  required String token,
  required void Function(Widget page) pushPage,
  required void Function(Widget page) pushReplacement,
  required void Function(Widget page) pushAndRemoveUntil,
}) async {
  final statusAmbiguidade = resultado?['status']?.toString().toLowerCase();
  final statusFace = resultado?['status']?.toString().toLowerCase();
  final statusCpf = resultado?['detail']?.toString().toLowerCase();
  final statusErro = resultado?['erro']?.toString();

  if (statusFace == 'nenhuma similaridade forte' ||
      statusCpf == 'cpf não encontrado na tabela identidade.') {
    await showNadaConstaDialog(context);

    pushAndRemoveUntil(TelaHome(perfil: perfil));
  } else if (statusErro != null &&
      statusErro.contains("Exception: Falha ao enviar imagem: 400")) {
    await showErrorFotoDialog(context, perfil);

    pushReplacement(FaceCameraPage(perfil: perfil));
  } else if (statusAmbiguidade == 'ambíguo') {
    final opcoes = <Map<String, dynamic>>[];

    final List<dynamic> pessoas = resultado?['possiveis_identidades'] ?? [];

    for (final pessoa in pessoas) {
      opcoes.add({
        'identidade': pessoa['identidade'],
        'ficha_criminal': pessoa['ficha_criminal'],
        'crimes': pessoa['ficha_criminal']?['crimes'] ?? [],
      });
    }

    if (opcoes.isNotEmpty) {
      final opcaoSelecionada = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AmbiguityPage(
            opcoes: opcoes,
            perfil: perfil,
            token: token,
          ),
        ),
      );
      if (opcaoSelecionada != null) {
        pushPage(FichaResultPage(
          ficha: opcaoSelecionada,
          perfil: perfil,
          token: token,
        ));
      }
    }
  }
}