import 'package:flutter/material.dart';
import 'package:vision_app/presentation/screens/buscacpf/ficha_result_tela.dart';
import 'package:vision_app/presentation/screens/camera/face_camera_page.dart';
import 'package:vision_app/presentation/screens/camera/popup_dialog_error_foto.dart';
import 'package:vision_app/presentation/screens/camera/popup_dialog_nada_consta.dart';
import 'package:vision_app/presentation/screens/home/tela_home.dart';
import 'package:vision_app/services/auth_token_service.dart';



class ResultadoPage extends StatefulWidget {
  final Map<String, dynamic> resultado;
  final Map<String, dynamic> perfil;
  

  const ResultadoPage({super.key, required this.resultado, required this.perfil});

  @override
  State<ResultadoPage> createState() => _ResultadoPageState();
}

class _ResultadoPageState extends State<ResultadoPage> {
  String? _token;

  @override
  void initState() {
    super.initState();
    _carregarToken().then((_) {
      _verificarResultado();
    });
  }

  Future<void> _carregarToken() async {
  final t = await AuthTokenService().getToken();
  setState(() {
    _token = t;
  });
  }


  void _verificarResultado() async {
    final statusFace = widget.resultado['status']?.toString().toLowerCase();
    final statusCpf = widget.resultado['detail']?.toString().toLowerCase();
    final statusErro = widget.resultado['erro']?.toString();


    if (statusFace == 'nenhuma similaridade forte' || statusCpf == 'cpf não encontrado na tabela identidade.') {
      await Future.delayed(Duration.zero);
      await showNadaConstaDialog(context);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TelaHome(perfil: widget.perfil),
          ),
        );
      }
    } else if (statusErro != null && statusErro.contains("Exception: Falha ao enviar imagem: 400")) {
      await Future.delayed(Duration.zero);
      await showErrorFotoDialog(context, widget.perfil);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
        
            builder: (context) => FaceCameraPage(perfil: widget.perfil),
          ),
        );
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

    return FichaResultPage(ficha: ficha, perfil: widget.perfil,);
  }

}
