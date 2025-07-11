import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Cep extends ParseObject implements ParseCloneable {
  Cep() : super('Cep');

  Cep.clone() : this();

  @override
  clone(Map<String, dynamic> map) => Cep.clone()..fromJson(map);

  String get cep => get<String>('cep') ?? '';
  set cep(String value) => set<String>('cep', value);

  String get logradouro => get<String>('logradouro') ?? '';
  set logradouro(String value) => set<String>('logradouro', value);

  String get complemento => get<String>('complemento') ?? '';
  set complemento(String value) => set<String>('complemento', value);

  String get bairro => get<String>('bairro') ?? '';
  set bairro(String value) => set<String>('bairro', value);

  String get localidade => get<String>('localidade') ?? '';
  set localidade(String value) => set<String>('localidade', value);

  String get uf => get<String>('uf') ?? '';
  set uf(String value) => set<String>('uf', value);

  String get ibge => get<String>('ibge') ?? '';
  set ibge(String value) => set<String>('ibge', value);

  String get gia => get<String>('gia') ?? '';
  set gia(String value) => set<String>('gia', value);

  String get ddd => get<String>('ddd') ?? '';
  set ddd(String value) => set<String>('ddd', value);

  String get siafi => get<String>('siafi') ?? '';
  set siafi(String value) => set<String>('siafi', value);
}
