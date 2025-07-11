import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:projeto_dio_viacep/pages/detail_page.dart';
import 'package:projeto_dio_viacep/pages/edit_page.dart';
import '../models/cep_model.dart';
import '../services/api_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _cepController = TextEditingController();
  final _searchController = TextEditingController();
  final _apiService = ApiService();
  List<Cep> _cepsCadastrados = [];
  List<Cep> _cepsFiltrados = [];
  bool _isLoading = false;

  final _cepMaskFormatter = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    _carregarCeps();
    _searchController.addListener(_filtrarCeps);
  }

  @override
  void dispose() {
    _cepController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _carregarCeps() async {
    setState(() {
      _isLoading = true;
    });
    _cepsCadastrados = await _apiService.listarCeps();
    _filtrarCeps();
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  void _filtrarCeps() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _cepsFiltrados = _cepsCadastrados;
      } else {
        _cepsFiltrados = _cepsCadastrados.where((cep) {
          return cep.cep.toLowerCase().contains(query) ||
              cep.logradouro.toLowerCase().contains(query) ||
              cep.localidade.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Future<void> _consultarECadastrarCep() async {
    if (_cepMaskFormatter.getUnmaskedText().isEmpty) return;
    setState(() {
      _isLoading = true;
    });
    final cepInfo = await _apiService.consultarCep(
      _cepMaskFormatter.getUnmaskedText(),
    );
    if (!mounted) return;
    if (cepInfo != null) {
      await _apiService.cadastrarCep(cepInfo);
      _cepController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('CEP encontrado e salvo com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      await _carregarCeps();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('CEP não encontrado ou inválido.'),
          backgroundColor: Colors.red,
        ),
      );
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _excluirCep(String objectId) async {
    setState(() {
      _isLoading = true;
    });
    await _apiService.excluirCep(objectId);
    if (!mounted) return;
    await _carregarCeps();
  }

  void _navigateToDetails(Cep cep) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailsScreen(cep: cep)),
    );
  }

  Future<void> _navigateToEdit(Cep cep) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditScreen(cep: cep)),
    );
    if (result == true) {
      _carregarCeps();
    }
  }

  void _copyToClipboard(Cep cep) {
    final address =
        "${cep.logradouro}, ${cep.bairro}, ${cep.localidade} - ${cep.uf}, ${cep.cep}";
    Clipboard.setData(ClipboardData(text: address)).then((_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Endereço copiado!')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta e Cadastro de CEP'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cepController,
              inputFormatters: [_cepMaskFormatter],
              decoration: const InputDecoration(
                labelText: 'Digite o CEP para consultar',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _consultarECadastrarCep,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading && _cepController.text.isNotEmpty
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : const Text('CONSULTAR CEP'),
            ),
            const SizedBox(height: 24),
            const Divider(),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar na lista',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _carregarCeps,
                child: _isLoading && _cepsFiltrados.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : _cepsFiltrados.isEmpty
                    ? Center(
                        child: Text(
                          _searchController.text.isEmpty
                              ? 'Nenhum CEP cadastrado ainda.'
                              : 'Nenhum resultado encontrado.',
                        ),
                      )
                    : ListView.builder(
                        itemCount: _cepsFiltrados.length,
                        itemBuilder: (context, index) {
                          final cep = _cepsFiltrados[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              onTap: () => _navigateToDetails(cep),
                              leading: const Icon(
                                Icons.location_on_outlined,
                                color: Colors.blue,
                              ),
                              title: Text("CEP: ${cep.cep}"),
                              subtitle: Text(
                                "${cep.logradouro}, ${cep.bairro}, ${cep.localidade} - ${cep.uf}",
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.orange,
                                    ),
                                    tooltip: 'Editar CEP',
                                    onPressed: () => _navigateToEdit(cep),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.copy,
                                      color: Colors.grey,
                                    ),
                                    tooltip: 'Copiar endereço',
                                    onPressed: () => _copyToClipboard(cep),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    tooltip: 'Excluir CEP',
                                    onPressed: () => _excluirCep(cep.objectId!),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
