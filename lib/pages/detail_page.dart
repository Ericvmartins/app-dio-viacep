import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/cep_model.dart';

class DetailsScreen extends StatelessWidget {
  final Cep cep;

  const DetailsScreen({Key? key, required this.cep}) : super(key: key);

  Future<void> _abrirNoMapa(BuildContext context) async {
    final query = Uri.encodeComponent(
      '${cep.logradouro}, ${cep.localidade}, ${cep.uf}',
    );
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir o mapa.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildDetailRow(String title, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes do CEP: ${cep.cep}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDetailRow('Logradouro', cep.logradouro),
            _buildDetailRow('Complemento', cep.complemento),
            _buildDetailRow('Bairro', cep.bairro),
            _buildDetailRow('Localidade', cep.localidade),
            _buildDetailRow('UF', cep.uf),
            _buildDetailRow('IBGE', cep.ibge),
            _buildDetailRow('GIA', cep.gia),
            _buildDetailRow('DDD', cep.ddd),
            _buildDetailRow('SIAFI', cep.siafi),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.map_outlined),
              label: const Text('VER NO MAPA'),
              onPressed: () => _abrirNoMapa(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
