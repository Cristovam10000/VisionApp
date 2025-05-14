import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_texts.dart';
import 'package:vision_app/presentation/screens/camera/face_camera_page.dart';
import 'package:vision_app/presentation/screens/home/pop-up.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../widgets/state/state.dart';
import '../../../routes/app_routes.dart';
import 'package:vision_app/core/theme/app_theme.dart';

class TelaHome extends StatelessWidget {
  final String? nomeUsuario;
  final Map<String, dynamic> perfil;

  const TelaHome({
    Key? key,
    this.nomeUsuario,
    required this.perfil,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;    // ...existing code...
    final nome = (nomeUsuario ?? (args is String ? args : (perfil['nome'] ?? 'Usuário')))
        .toString()
        .split(' ')
        .first;
// ...existing code...

    // Usa os dados do perfil recebido
    final nomeCompleto = perfil['nome'] ?? 'Nome não informado';
    final cargo = perfil['cargo'] ?? 'Cargo não informado';
    final classe = perfil['nivel_classe'] ?? 'Classe não informada';
    final matricula = perfil['matricula'] ?? 'Matrícula não informada';

    return Scaffold(
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
      drawer: Drawer(
          backgroundColor: const Color(0xFF181B1F), // cor escura de fundo
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                // Título centralizado
                Text(
                  'VisionApp',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                // Ícone centralizado (troque por Image.asset se quiser)
                const Icon(
                  Icons.shield_outlined,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                // Nome do usuário centralizado
                Text(
                  nomeCompleto,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                // Informações do usuário
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Cargo: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: cargo),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Classe: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: classe),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Matrícula: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: matricula),
                            ],
                          ),
                        ),
                      ],
                      ),
                    ),
                  ),
                ),
              // Botão de sair
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 32),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    icon: const Icon(Icons.logout, color: Color(0xFF0B5ED7), size: 32),
                    label: const Text(
                      'Sair',
                      style: TextStyle(
                        color: Color(0xFF0B5ED7),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      mostrarDialogoLogout(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF0B5ED7),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
              Container(
                  child: Text(
                    'Bem Vindo,\n$nome!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
              ),
            const SizedBox(height: 140),

            BotaoPersonalizado(
              assetImagePath: 'assets/lupa_cpf.png',
              texto: 'Busca por CPF',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PageTwo()),
                );
              },
            ),
            const SizedBox(height: 20),
            BotaoPersonalizado(
              assetImagePath: 'assets/face_recognition.png',
              texto: 'Pesquisa Criminal',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FaceCameraPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Botão com ícone e texto
class BotaoPersonalizado extends StatelessWidget {
  final IconData? icone;
  final String? assetImagePath;
  final String texto;
  final VoidCallback onPressed;

  const BotaoPersonalizado({
    Key? key,
    this.icone,
    this.assetImagePath,
    required this.texto,
    required this.onPressed,
  }) : super(key: key);

  @override
    Widget build(BuildContext context) {
      Widget? visual;
      if (assetImagePath != null) {
        visual = Image.asset(assetImagePath!, width: 70, height: 70);
      } else if (icone != null) {
        visual = Icon(icone, size: 50);
      }

      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(273, 150),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.all(16),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (visual != null) visual,
            if (visual != null) const SizedBox(height: 20),
            Text(texto, style: const TextStyle(fontSize: 14)),
          ],
        ),
      );
    }
}



// Página 2
class PageTwo extends StatelessWidget {
  const PageTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página 2')),
      body: const Center(child: Text('Conteúdo da Página 2')),
    );
  }
}