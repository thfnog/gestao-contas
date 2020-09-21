import 'package:json_annotation/json_annotation.dart';

import 'converters/CustomDateTimeConverter.dart';

part 'empresa.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class Empresa {
  int id;

  String nome;
  String email;
  String cnpj;
  String responsavel;

  Empresa({this.id, this.nome, this.email, this.cnpj, this.responsavel});

  factory Empresa.fromJson(Map<String, dynamic> json) =>
      _$EmpresaFromJson(json);

  Map<String, dynamic> toJson() => _$EmpresaToJson(this);

}