// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conta _$ContaFromJson(Map<String, dynamic> json) {
  return Conta(
    id: json['id'] as int,
    parcelas: json['parcelas'] as int,

    formaPagamento: json['formaPagamento'] as String,
    tipoConta: json['tipoConta'] as String,
    status: json['status'] as String,
    descricao: json['descricao'] as String,
    observacoes: json['observacoes'] as String,
    numDocumento: json['numDocumento'] as String,

    valor: json['valor'] as double,
    valorParcelado: json['valorParcelado'] as double,
    juros: json['juros'] as double,
    desconto: json['desconto'] as double,

    dataCompetencia: const CustomDateTimeConverter()
        .fromJsonString(json['dataCompetencia'] as String),
    dataVencimento: const CustomDateTimeConverter()
        .fromJsonString(json['dataVencimento'] as String),
    dataPagamento: const CustomDateTimeConverter()
        .fromJsonString(json['dataPagamento'] as String),
    dataEmissao: const CustomDateTimeConverter()
        .fromJsonString(json['dataEmissao'] as String),

    fornecedor: json['fornecedor'] == null
        ? null
        : Empresa.fromJson(json['fornecedor'] as Map<String, dynamic>),
    contaOrigem: json['contaOrigem'] == null
        ? null
        : Empresa.fromJson(json['contaOrigem'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ContaToJson(Conta instance) => <String, dynamic>{
      'id': instance.id,
      'parcelas': instance.parcelas,

      'formaPagamento': instance.formaPagamento,
      'tipoConta': instance.tipoConta,
      'status': instance.status,
      'descricao': instance.descricao,
      'observacoes': instance.observacoes,
      'numDocumento': instance.numDocumento,

      'valor': instance.valor,
      'valorParcelado': instance.valorParcelado,

      'dataCompetencia':
        const CustomDateTimeConverter().toJson(instance.dataCompetencia),
      'dataVencimento':
          const CustomDateTimeConverter().toJson(instance.dataVencimento),
      'dataPagamento':
          const CustomDateTimeConverter().toJson(instance.dataPagamento),
      'dataEmissao':
          const CustomDateTimeConverter().toJson(instance.dataEmissao),

      'contaOrigem': instance.contaOrigem,
      'fornecedor': instance.fornecedor,
    };
