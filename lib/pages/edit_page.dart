import 'package:flutter/material.dart';
import '../models/cep_model.dart';
import '../services/api_services.dart';

class EditScreen extends StatefulWidget {
  final Cep cep;

  const EditScreen({Key? key, required this.cep}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late TextEditingController _logradouroController;
  late TextEditingController _complementoController;
  late TextEditingController _bairroController;
  late TextEditingController _localidadeController;
  late TextEditingController _ufController;

  @override
  void initState() {
    super.initState();
    _logradouroController = TextEditingController(text: widget.cep.logradouro);
    _complementoController = TextEditingController(
      text: widget.cep.complemento,
    );
    _bairroController = TextEditingController(text: widget.cep.bairro);
    _localidadeController = TextEditingController(text: widget.cep.localidade);
    _ufController = TextEditingController(text: widget.cep.uf);
  }

  @override
  void dispose() {
    _logradouroController.dispose();
    _complementoController.dispose();
    _bairroController.dispose();
    _localidadeController.dispose();
    _ufController.dispose();
    super.dispose();
  }

  Future<void> _salvarAlteracoes() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      widget.cep.logradouro = _logradouroController.text;
      widget.cep.complemento = _complementoController.text;
      widget.cep.bairro = _bairroController.text;
      widget.cep.localidade = _localidadeController.text;
      widget.cep.uf = _ufController.text;

      await _apiService.atualizarCep(widget.cep);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CEP atualizado com sucesso!')),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar CEP: ${widget.cep.cep}')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _logradouroController,
                decoration: const InputDecoration(labelText: 'Logradouro'),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _complementoController,
                decoration: const InputDecoration(labelText: 'Complemento'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bairroController,
                decoration: const InputDecoration(labelText: 'Bairro'),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _localidadeController,
                decoration: const InputDecoration(
                  labelText: 'Localidade/Cidade',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ufController,
                decoration: const InputDecoration(labelText: 'UF'),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _salvarAlteracoes,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('SALVAR ALTERAÇÕES'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
