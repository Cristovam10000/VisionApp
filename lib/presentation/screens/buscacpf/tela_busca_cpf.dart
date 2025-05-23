// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:vision_app/presentation/screens/camera/popup_dialog_nada_consta.dart';
import 'package:vision_app/presentation/screens/home/tela_home.dart';
import 'package:vision_app/presentation/widgets/state/loading_dialog.dart';
import 'package:vision_app/presentation/widgets/state/navbar.dart';
import 'package:vision_app/presentation/widgets/state/state.dart';
import 'package:vision_app/services/upload_service.dart';
import 'package:vision_app/presentation/screens/resultados/ficha_result_tela.dart';

class TelaBuscaCpf extends StatefulWidget {
  final String token;
  final Map<String, dynamic>? perfil;

  const TelaBuscaCpf({super.key, required this.token, this.perfil});

  @override
  _TelaBuscaCpfState createState() => _TelaBuscaCpfState();
}

class _TelaBuscaCpfState extends State<TelaBuscaCpf> {
  final _cpfCtrl = TextEditingController();
  final _uploadService = UploadService();
  final bool _isLoading = false;
  String? _cpfError; // <- Mensagem de erro

  @override
  void initState() {
    super.initState();
    _cpfCtrl.clear(); // Limpa o campo CPF ao entrar na tela
  }

  Future<void> buscarFicha() async {
    final cpf = _cpfCtrl.text.trim();

    setState(() {
      _cpfError = null; // Limpa erro anterior
    });

    if (cpf.isEmpty) {
      setState(() {
        _cpfError = 'Por favor, digite um CPF';
      });
      return;
    }

    if (cpf.length != 11) {
      setState(() {
        _cpfError = 'CPF deve ter 11 dígitos';
      });
      return;
    }

    if (widget.token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token ausente. Faça login novamente.')),
      );
      return;
    }

    showLoadingDialog(context, mensagem: 'Buscando ficha...');

    try {
      final ficha = await _uploadService.buscarFichaPorCpf(cpf, widget.token);
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => FichaResultPage(
                ficha: ficha,
                perfil: widget.perfil,
                token: widget.token,
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
              builder: (context) => TelaHome(perfil: widget.perfil),
            ),
            (Route<dynamic> route) => false, // Remove todas
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorPalette.dark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => TelaHome(perfil: widget.perfil),
        //         ),
        //       );

        //   },
        // ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Buscar por\nCPF',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: ColorPalette.azulMarinho,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'Digite o CPF',
                    style: Theme.of(context).textTheme.displayMedium
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: 256,
                    child: TextField(
                      controller: _cpfCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(
                          11,
                        ), // por exemplo, limite 11 caracteres
                      ],
                      style: const TextStyle(color: ColorPalette.preto),
                      decoration: InputDecoration(
                        hintText: 'Pesquisar',
                        hintStyle: const TextStyle(color: ColorPalette.cinza),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: ColorPalette.cinza,
                        ),
                        filled: true,
                        fillColor: ColorPalette.branco,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        errorText: _cpfError,
                      ),
                    ),
                  ),

                  const SizedBox(height: 34),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                        height: 48,
                        child: Button(
                          text: "Pesquisar",
                          onPressed: buscarFicha,
                        ),
                      ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavbar(
        currentIndex: 2,
        perfil: widget.perfil,
        token: widget.token,
      ),
    );
  }

  @override
  void dispose() {
    _cpfCtrl.dispose();
    super.dispose();
  }
}
