// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:vision_app/presentation/pages/resultados/ficha_result_tela.dart';
import 'package:vision_app/data/model/fichamodel.dart';
import '../../controllers/verificar_resultado_controller.dart';


class ResultadoPage extends StatefulWidget {
  final Map<dynamic, dynamic>? resultado;
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


    final identidade = (widget.resultado?['identidade'] ?? {}).cast<String, dynamic>();
    final fichaCriminal = (widget.resultado?['ficha_criminal'] ?? {}).cast<String, dynamic>();

    final ficha = FichaModel.fromFacial(identidade, fichaCriminal);

    return FichaResultPage(
      ficha: ficha.toMap(), // ou só ficha, se a tela aceitar o model
      perfil: widget.perfil,
      token: widget.token,
    );
  }
}
