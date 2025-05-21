import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:vision_app/presentation/screens/buscacpf/tela_busca_cpf.dart';
import 'package:vision_app/presentation/screens/home/drawer_perfil.dart';
import 'package:vision_app/presentation/screens/home/pop-up_facerules.dart';
import 'package:vision_app/services/auth_token_service.dart';
import '../../widgets/state/state.dart';

class TelaHome extends StatefulWidget {
  final String? nomeUsuario;
  final Map<String, dynamic>? perfil;

  const TelaHome({
    super.key,
    this.nomeUsuario,
    this.perfil,
  });

  @override
  State<TelaHome> createState() => _TelaHomeState();
}

class _TelaHomeState extends State<TelaHome> {
  late String nome;
  late String nomeCompleto;
  late String cargo;
  late String classe;
  late String matricula;

  // Variáveis de token (lógica apenas)
  String? _token;

  @override
  void initState() {
    super.initState();
    _verificarToken();
  }

  // Apenas lógica de verificação de token, sem exibir no front
  Future<void> _verificarToken() async {
    final t = await AuthTokenService().getToken();
    setState(() {
      _token = t;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;

    nome = (widget.nomeUsuario ??
            (args is String ? args : (widget.perfil?['nome'] ?? 'Usuário')))
        .toString()
        .split(' ')
        .first;

    nomeCompleto = widget.perfil?['nome'] ?? 'Nome não informado';
    cargo = widget.perfil?['cargo'] ?? 'Cargo não informado';
    classe = widget.perfil?['nivel_classe'] ?? 'Classe não informada';
    matricula = widget.perfil?['matricula'] ?? 'Matrícula não informada';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: CustomDrawer(
        nomeCompleto: nomeCompleto,
        cargo: cargo,
        classe: classe,
        matricula: matricula,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Bem Vindo,\n$nome!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: ColorPalette.branco,
                ),
              ),
              const SizedBox(height: 120),
              HomeButton(
                assetImagePath: 'assets/lupa_cpf.png',
                texto: 'Busca por CPF',
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaBuscaCpf(token: _token ?? '',
                        perfil: widget.perfil,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              HomeButton(
                assetImagePath: 'assets/face_recognition.png',
                texto: 'Pesquisa Criminal',
                onPressed: () {
                  mostrarPopUpRegrasFace(context: context, perfil: widget.perfil);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

