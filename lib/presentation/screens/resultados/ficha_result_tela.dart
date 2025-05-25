import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vision_app/presentation/screens/resultados/image_popup.dart';
import 'package:vision_app/presentation/screens/home/tela_home.dart';
import 'package:vision_app/presentation/screens/resultados/vulgo.dart';
import 'package:vision_app/presentation/widgets/state/formatacao.dart';
import 'package:vision_app/presentation/widgets/state/infotextline.dart';
import 'package:vision_app/presentation/widgets/state/navbar.dart';

class FichaResultPage extends StatefulWidget {
  final Map<String, dynamic>? ficha;
  final Map<String, dynamic>? perfil;
  final String token;
  final bool fromAmbiguity;

  const FichaResultPage({
    super.key,
    this.ficha,
    this.perfil,
    required this.token,
    this.fromAmbiguity = false,
  });

  @override
  State<FichaResultPage> createState() => _FichaResultPageState();
}

class _FichaResultPageState extends State<FichaResultPage> {
  bool _isScrolled = false;

  void _onScroll(ScrollNotification notification) {
    if (notification.metrics.pixels > 0 && !_isScrolled) {
      setState(() {
        _isScrolled = true;
      });
    } else if (notification.metrics.pixels <= 0 && _isScrolled) {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.dark,
      appBar: AppBar(
        backgroundColor: _isScrolled ? ColorPalette.navbar : ColorPalette.dark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (widget.fromAmbiguity) {
              Navigator.pop(context);
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaHome(perfil: widget.perfil),
                ),
                (Route<dynamic> route) => false,
              );
            }
          },
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _onScroll(notification);
          return true;
        },
        child: widget.ficha == null || widget.ficha!.isEmpty
            ? const Center(
                child: Text(
                  'Nenhuma informação encontrada.',
                  style: TextStyle(color: ColorPalette.branco),
                ),
              )
            : ListView(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 40,
                  right: 37,
                  bottom: 24,
                ),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: ColorPalette.dark,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => ImagePopup(
                                    imageUrl: widget.ficha?['foto_url'] ??
                                        'https://i.imgur.com/j6xgQ7D.png',
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                radius: 65,
                                backgroundImage: NetworkImage(
                                  widget.ficha?['foto_url'] ??
                                      'https://i.imgur.com/j6xgQ7D.png',
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: widget.ficha?['nome'] ??
                                        'Nome não encontrado',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: ColorPalette.branco,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Transform.translate(
                                  offset: const Offset(1, -3),
                                  child: SvgPicture.asset(
                                    'assets/Iconperson.svg',
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  obterVulgo(widget.ficha),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: ColorPalette.branco,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 1),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: ColorPalette.dark,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                              'CPF',
                              formatCpf(widget.ficha?['cpf']),
                            ),
                            const SizedBox(height: 15),
                            _buildInfoRow(
                              'Data de Nascimento',
                              widget.ficha?['data_nascimento'],
                            ),
                            const SizedBox(height: 15),
                            _buildInfoRow(
                              'Nome da Mãe',
                              widget.ficha?['nome_mae'],
                            ),
                            const SizedBox(height: 15),
                            _buildInfoRow(
                              'Nome do Pai',
                              widget.ficha?['nome_pai'],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Resumo Criminal',
                        style: TextStyle(
                          color: ColorPalette.branco,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (widget.ficha?['crimes'] != null)
                        ...List.generate(
                          widget.ficha?['crimes'].length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: CrimeCard(
                              crime: widget.ficha?['crimes'][index],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
      ),
      bottomNavigationBar: CustomNavbar(
        currentIndex: -1,
        perfil: widget.perfil,
        token: widget.token,
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: ColorPalette.branco,
              fontSize: 19,
            ),
          ),
          TextSpan(
            text: value ?? 'Não informado',
            style: const TextStyle(color: ColorPalette.branco, fontSize: 19),
          ),
        ],
      ),
    );
  }
}

class CrimeCard extends StatelessWidget {
  final Map<String, dynamic> crime;

  const CrimeCard({super.key, required this.crime});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorPalette.azulMarinho,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 12,
          left: 16,
          right: 16,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mandato',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: crime['status'] == 'Em Aberto'
                        ? ColorPalette.vermelhoPaleta
                        : ColorPalette.cinza,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    crime['status'] ?? 'Desconhecido',
                    style: const TextStyle(
                      color: ColorPalette.branco,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            infoTextLine('Data: ', crime['data_ocorrencia'] ?? 'Não informada'),
            const SizedBox(height: 6),
            infoTextLine('Artigo: ', crime['artigo'] ?? 'Não informado'),
            const SizedBox(height: 6),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/LocationMarkerOutline.svg',
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  '${crime['cidade'] ?? ''}, ${crime['estado'] ?? ''}',
                  style: const TextStyle(color: ColorPalette.branco),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
