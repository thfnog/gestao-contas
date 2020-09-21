import 'package:json_annotation/json_annotation.dart';

import 'converters/CustomDateTimeConverter.dart';
import 'empresa.dart';

part 'conta.g.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class Conta {
  int id;
  int parcelas;

  String formaPagamento;
  String tipoConta;
  String status;
  String descricao;
  String observacoes;
  String numDocumento;

  double valor;
  double valorParcelado;
  double juros;
  double desconto;

  DateTime dataCompetencia;
  DateTime dataVencimento;
  DateTime dataPagamento;
  DateTime dataEmissao;

  Empresa fornecedor;
  Empresa contaOrigem;

  Conta({this.id, this.parcelas, this.formaPagamento, this.tipoConta, this.status,
      this.descricao, this.observacoes, this.numDocumento,
      this.valor, this.valorParcelado, this.juros, this.desconto,
      this.dataCompetencia, this.dataVencimento, this.dataPagamento, this.dataEmissao,
      this.fornecedor, this.contaOrigem});

  factory Conta.fromJson(Map<String, dynamic> json) =>
      _$ContaFromJson(json);

  Map<String, dynamic> toJson() => _$ContaToJson(this);

}