import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/src/model/conta.dart';
import 'package:flutter_web_dashboard/src/model/converters/CustomDateTimeConverter.dart';
import 'package:intl/intl.dart';

class ContasDataSource extends DataTableSource {
  List<Conta> contas;
  BuildContext context;

  ContasDataSource(this.contas, this.context);

  void sort<T>(Comparable<T> getField(Conta d), bool ascending) {
    contas.sort((Conta a, Conta b) {
      if (!ascending) {
        final Conta c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
  }

  int _selectedCount = 0;
  final formatCurrency = new NumberFormat.simpleCurrency(locale: "pt_BR");

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= contas.length) return null;
    final Conta conta = contas[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text('${conta.id}')),
        DataCell(Text('${conta.numDocumento}')),
        DataCell(Text('${formatterDate.format(conta.dataEmissao)}')),
        DataCell(Text('${formatterDate.format(conta.dataVencimento)}')),
        DataCell(Text('${formatCurrency.format(conta.valor ?? 0)}')),
        DataCell(Text('${formatCurrency.format(conta.juros ?? 0)}')),
        DataCell(Text('${formatCurrency.format(conta.desconto ?? 0)}')),
        DataCell(Text('${conta.status}')),
        DataCell(Container(
            width: 150,
            child: Row(children: <Widget>[
              Flexible(child: Text('${conta.contaOrigem?.nome}', overflow: TextOverflow.ellipsis,))
            ]))),
        DataCell(Container(
            width: 150,
            child: Row(children: <Widget>[
              Flexible(child: Text('${conta.fornecedor?.nome}', overflow: TextOverflow.ellipsis,))
            ]))),
        DataCell(conta.formaPagamento != null ? Text('${conta.formaPagamento}') : Text('')),
        DataCell(conta.tipoConta != null ? Text('${conta.tipoConta}') : Text('')),
        DataCell(Container(
            width: 200,
            child: Row(children: <Widget>[
              Flexible(child: Text('${conta.descricao != null ? conta.descricao : ''}', overflow: TextOverflow.ellipsis))
            ]))),
      ],
    );
  }

  @override
  int get rowCount => contas.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
