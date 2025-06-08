// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:vision_app/presentation/pages/resultados/ficha_result_tela.dart';
// import 'package:vision_app/presentation/pages/camera/face_camera_page.dart';
// import 'package:vision_app/presentation/pages/camera/popup_dialog_error_foto.dart';
// import 'package:vision_app/presentation/pages/camera/popup_dialog_nada_consta.dart';
// import 'package:vision_app/presentation/pages/camera/tela_ambiguidade.dart';
// import 'package:vision_app/presentation/pages/home/tela_home.dart';
import '../../controllers/verificar_resultado_controller.dart';

class ResultadoPage extends StatefulWidget {
  final Map<String, dynamic>? resultado;
  final Map<String, dynamic>? perfil;
  final String token;

  const ResultadoPage({
    super.key,
    required this.resultado,
    this.perfil,
    required this.token,
  });

  @override
  State<ResultadoPage> createState() => _ResultadoPageState();
}

class _ResultadoPageState extends State<ResultadoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verificarResultado();
    });
  }

  void _verificarResultado() {
    verificarResultado(
      context: context,
      resultado: widget.resultado,
      perfil: widget.perfil,
      token: widget.token,
      pushPage: (page) => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      pushReplacement: (page) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page)),
      pushAndRemoveUntil: (page) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => page),
        (Route<dynamic> route) => false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final identidade = widget.resultado?['identidade'] ?? {};
    final fichaCriminal = widget.resultado?['ficha_criminal'] ?? {};
    final fichaInfo = fichaCriminal['ficha_criminal'] ?? {};
    final crimes = fichaCriminal['crimes'] ?? [];

    final ficha = {
      'cpf': identidade['cpf'],
      'nome': identidade['nome'],
      'nome_mae': identidade['nome_mae'],
      'nome_pai': identidade['nome_pai'],
      'data_nascimento': identidade['data_nascimento'],
      'foto_url': identidade['url_face'],
      'vulgo': fichaInfo['vulgo'],
      'crimes': crimes,
    };


    return FichaResultPage(ficha: ficha, perfil: widget.perfil, token: widget.token);
  }
}
