import 'package:flutter/material.dart';
import 'package:vision_app/presentation/screens/buscacpf/ficha_result_tela.dart';
import 'package:vision_app/presentation/screens/camera/face_camera_page.dart';
import 'package:vision_app/presentation/screens/camera/popup_dialog_error_foto.dart';
import 'package:vision_app/presentation/screens/camera/popup_dialog_nada_consta.dart';
import 'package:vision_app/presentation/screens/camera/tela_ambiguidade.dart';
import 'package:vision_app/presentation/screens/home/tela_home.dart';

class ResultadoPage extends StatefulWidget {
  final Map<String, dynamic> resultado;
  final Map<String, dynamic> perfil;

  const ResultadoPage({
    super.key,
    required this.resultado,
    required this.perfil,
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

  void _verificarResultado() async {
    final statusAmbiguidade = widget.resultado['status']?.toString().toLowerCase();
    final statusFace = widget.resultado['status']?.toString().toLowerCase();
    final statusCpf = widget.resultado['detail']?.toString().toLowerCase();
    final statusErro = widget.resultado['erro']?.toString();
    final opcoes = widget.resultado['opcoes'];


    if (statusFace == 'nenhuma similaridade forte' ||
        statusCpf == 'cpf não encontrado na tabela identidade.') {
      await showNadaConstaDialog(context);

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => TelaHome(perfil: widget.perfil),
          ),
          (Route<dynamic> route) => false, // Remove todas
        );
      }
    } else if (statusErro != null &&
        statusErro.contains("Exception: Falha ao enviar imagem: 400")) {
      await showErrorFotoDialog(context, widget.perfil);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FaceCameraPage(perfil: widget.perfil),
          ),
        );
      }
    } else if (statusAmbiguidade == 'ambíguo') {
      // Extrai todas as opções encontradas dinamicamente
      final opcoes = [];
      if (widget.resultado['primeiro_encontrado'] != null) {
        opcoes.add({
          'identidade': widget.resultado['primeiro_encontrado']['identidade'],
          'ficha_criminal':
              widget.resultado['primeiro_encontrado']['ficha_criminal'],
          'crimes': widget.resultado['primeiro_encontrado']['crimes'],
        });
      }
      if (widget.resultado['segundo_encontrado'] != null) {
        opcoes.add({
          'identidade': widget.resultado['segundo_encontrado']['identidade'],
          'ficha_criminal':
              widget.resultado['segundo_encontrado']['ficha_criminal'],
          'crimes': widget.resultado['segundo_encontrado']['crimes'],
        });
      }
      if (widget.resultado['terceiro_encontrado'] != null) {
        opcoes.add({
          'identidade': widget.resultado['terceiro_encontrado']['identidade'],
          'ficha_criminal':
              widget.resultado['terceiro_encontrado']['ficha_criminal'],
          'crimes': widget.resultado['terceiro_encontrado']['crimes'],
        });
      }

      // Verifica se há opções para exibir
      if (opcoes.isNotEmpty) {
        // Navega diretamente para a página de ambiguidade
        final opcaoSelecionada = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AmbiguityPage(opcoes: opcoes, perfil: widget.perfil,),
          ),
        );
        if (opcaoSelecionada != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => FichaResultPage(
                    ficha: opcaoSelecionada,
                    perfil: widget.perfil,
                  ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final identidade = widget.resultado['identidade'] ?? {};
    final fichaCriminal = widget.resultado['ficha_criminal'] ?? {};
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

    return FichaResultPage(ficha: ficha, perfil: widget.perfil);
  }
}
