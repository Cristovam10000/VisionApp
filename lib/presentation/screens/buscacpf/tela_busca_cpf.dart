import 'package:flutter/material.dart';
import 'package:vision_app/services/upload_service.dart';
import 'package:vision_app/presentation/screens/buscacpf/ficha_result_tela.dart';
import 'package:vision_app/presentation/widgets/state/navbar.dart';

class TelaBuscaCpf extends StatefulWidget {
  final String? token;

  const TelaBuscaCpf({Key? key, required this.token}) : super(key: key);

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
        MaterialPageRoute(builder: (_) => FichaResultPage(ficha: ficha)),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar ficha: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar CPF'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Buscar ficha por CPF',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _cpfCtrl,
              decoration: const InputDecoration(
                labelText: 'Digite o CPF',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
                    onPressed: (widget.token != null) ? buscarFicha : null,
                    icon: const Icon(Icons.search),
                    label: const Text('Buscar'),
                  ),
          ],
        ),
      ),
     //  bottomNavigationBar: navbarContainer(), 
    );
  }

  @override
  void dispose() {
    _cpfCtrl.dispose();
    super.dispose();
  }
}
