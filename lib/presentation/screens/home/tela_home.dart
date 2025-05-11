import 'package:flutter/material.dart';
import 'package:vision_app/presentation/screens/buscacpf/ficha_result_tela.dart';
import 'package:vision_app/services/auth_token_service.dart';
import 'package:vision_app/services/upload_service.dart';

// Seu primeiro widget personalizado: TelaHome
class TelaHome extends StatefulWidget {

  final Map<String, dynamic> perfil;
  
  const TelaHome({super.key, required this.perfil});

    @override
  State<TelaHome> createState() => _TelaHomeState();

}


class _TelaHomeState extends State<TelaHome> {

  final _cpfCtrl = TextEditingController();
  final _uploadService = UploadService();
  bool _isLoading = false;
  String? _tokenStatus;
  String? _token;


  @override
  void initState() {
    super.initState();
    _verificarToken();
  }

  Future<void> _verificarToken() async {
    // carrega do SharedPreferences + cache
    final t = await AuthTokenService().getToken(); 
    setState(() {
      _token = t;
      _tokenStatus = (t != null && t.isNotEmpty)
        ? 'Token presente: ${t.substring(0, 10)}...'
        : 'Token ausente. Faça login novamente';
    });
  }

  Future<void> buscarFicha() async {
    final cpf = _cpfCtrl.text.trim();
    if (cpf.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, digite um CPF')),
      );
      return;
    }
    if (_token == null || _token!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token ausente. Faça login novamente.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final ficha = await _uploadService.buscarFichaPorCpf(cpf, _token!);
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
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _verificarToken),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Bem-vindo, ${widget.perfil['nome'] ?? 'Usuário'}!',
                style: Theme.of(ctx).textTheme.titleLarge),
            if (_tokenStatus != null)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _tokenStatus!.contains('presente')
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  border: Border.all(
                    color: _tokenStatus!.contains('presente')
                        ? Colors.green
                        : Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _tokenStatus!.contains('presente')
                          ? Icons.check_circle
                          : Icons.error,
                      color: _tokenStatus!.contains('presente')
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Flexible(child: Text(_tokenStatus!)),
                  ],
                ),
              ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(ctx, '/camera'),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Abrir Câmera'),
            ),
            const SizedBox(height: 40),
            const Text('Buscar ficha por CPF',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: (_token != null) ? buscarFicha : null,
                    icon: const Icon(Icons.search),
                    label: const Text('Buscar'),
                  ),
          ],
        ),
      ),
    );
}

 @override
  void dispose() {
    _cpfCtrl.dispose();
    super.dispose();
  }
}