// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vision_app/core/constants/app_colors.dart';
// import 'package:vision_app/presentation/pages/camera/popup_dialog_nada_consta.dart';
// import 'package:vision_app/presentation/pages/home/tela_home.dart';
// import 'package:vision_app/presentation/widgets/loading_dialog.dart';
import 'package:vision_app/presentation/widgets/navbar.dart';
import 'package:vision_app/presentation/widgets/button.dart';
// import 'package:vision_app/core/services/upload_service.dart';
// import 'package:vision_app/presentation/pages/resultados/ficha_result_tela.dart';
import '../../controllers/busca_cpf_controller.dart';

class TelaBuscaCpf extends StatefulWidget {
  final String token;
  final Map<String, dynamic>? perfil;

  const TelaBuscaCpf({super.key, required this.token, this.perfil});

  @override
  _TelaBuscaCpfState createState() => _TelaBuscaCpfState();
}

class _TelaBuscaCpfState extends State<TelaBuscaCpf> with BuscaCpfController {
  final _cpfCtrl = TextEditingController();
  final bool _isLoading = false;
  String? _cpfError;

  @override
  void initState() {
    super.initState();
    _cpfCtrl.clear(); // Limpa o campo CPF ao entrar na tela
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorPalette.dark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ), // Troque para o ícone que quiser
          onPressed: () {
            Navigator.pop(context); // Mantém o comportamento padrão de voltar
          },
        ),
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
                          onPressed: () {
                            buscarFicha(
                              context: context,
                              cpfCtrl: _cpfCtrl,
                              token: widget.token,
                              perfil: widget.perfil,
                              setCpfError: (err) => setState(() => _cpfError = err),
                            );
                          },
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
