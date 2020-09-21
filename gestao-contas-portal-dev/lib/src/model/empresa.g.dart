// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'empresa.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Empresa _$EmpresaFromJson(Map<String, dynamic> json) {
  return Empresa(
    id: json['id'] as int,
    nome: json['nome'] as String,
    cnpj: json['cnpj'] as String,
    responsavel: json['responsavel'] as String
  );
}

Map<String, dynamic> _$EmpresaToJson(Empresa instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'email': instance.email,
      'cnpj': instance.cnpj,
      'responsavel': instance.responsavel
    };
