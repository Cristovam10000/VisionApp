import 'package:flutter/material.dart';
import 'package:vision_app/presentation/screens/camera/popup_dialog_nada_consta.dart';
import 'package:vision_app/presentation/screens/home/tela_home.dart';
import 'package:vision_app/presentation/widgets/state/state.dart';
import 'package:vision_app/services/upload_service.dart';
import 'package:vision_app/presentation/screens/buscacpf/ficha_result_tela.dart';

class TelaBuscaCpf extends StatefulWidget {
  final String? token;
  final Map<String, dynamic> perfil;

  const TelaBuscaCpf({Key? key, required this.token, required this.perfil}) : super(key: key);

  @override
  _TelaBuscaCpfState createState() => _TelaBuscaCpfState();
}

class _TelaBuscaCpfState extends State<TelaBuscaCpf> {
  final _cpfCtrl = TextEditingController();
  final _uploadService = UploadService();
  bool _isLoading = false;

  Future<void> buscarFicha() async {
    final cpf = _cpfCtrl.text.trim();
    if (cpf.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, digite um CPF')),
      );
      return;
    }
    if (widget.token == null || widget.token!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token ausente. Faça login novamente.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final ficha = await _uploadService.buscarFichaPorCpf(cpf, widget.token!);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FichaResultPage(ficha: ficha, perfil: widget.perfil)),
      );
    } catch (e) {
      if (mounted) {
        await showNadaConstaDialog(context); // Espera o usuário fechar o diálogo

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TelaHome(perfil: widget.perfil),
            ),
          );
        }
      }

    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF0F1218),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Buscar por\nCPF',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              padding: const EdgeInsets.all(45),
              decoration: BoxDecoration(
                color: const Color(0xFF0F253F),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    'Digite o CPF',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextField(
                    autofocus: false,
                    controller: _cpfCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    decoration: InputDecoration(
                      hintText: 'Pesquisar',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          height: 48,
                          child: Button(text: "Pesquisar", onPressed: buscarFicha)
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cpfCtrl.dispose();
    super.dispose();
  }
}
