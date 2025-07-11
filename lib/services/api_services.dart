import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../models/cep_model.dart';

class ApiService {
  final String viaCepBaseUrl = 'https://viacep.com.br/ws';

  Future<Cep?> consultarCep(String cep) async {
    final response = await http.get(Uri.parse('$viaCepBaseUrl/$cep/json/'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['erro'] != true) {
        return Cep()
          ..cep = json['cep']
          ..logradouro = json['logradouro']
          ..complemento = json['complemento']
          ..bairro = json['bairro']
          ..localidade = json['localidade']
          ..uf = json['uf']
          ..ibge = json['ibge']
          ..gia = json['gia']
          ..ddd = json['ddd']
          ..siafi = json['siafi'];
      }
    }
    return null;
  }

  Future<void> cadastrarCep(Cep cep) async {
    final queryBuilder = QueryBuilder<Cep>(Cep())..whereEqualTo('cep', cep.cep);
    final responseQuery = await queryBuilder.query();

    if (responseQuery.success &&
        (responseQuery.results == null || responseQuery.results!.isEmpty)) {
      await cep.save();
    }
  }

  Future<List<Cep>> listarCeps() async {
    final response = await Cep().getAll();
    if (response.success && response.results != null) {
      return response.results!.map((e) => e as Cep).toList();
    }
    return [];
  }

  Future<void> atualizarCep(Cep cep) async {
    await cep.save();
  }

  Future<void> excluirCep(String objectId) async {
    var cep = Cep()..objectId = objectId;
    await cep.delete();
  }
}
