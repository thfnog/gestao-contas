import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/src/commons/theme.dart';
import 'package:flutter_web_dashboard/src/model/conta.dart';
import 'package:flutter_web_dashboard/src/model/converters/CustomDateTimeConverter.dart';
import 'package:flutter_web_dashboard/src/model/empresa.dart';
import 'package:flutter_web_dashboard/src/pages/nova_conta.dart';
import 'package:flutter_web_dashboard/src/widget/card_tile.dart';
import 'package:flutter_web_dashboard/src/widget/contas_data_table.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class TelaContasAPagar extends StatefulWidget {
  @override
  TelaContasAPagarState createState() => TelaContasAPagarState();
}

class TelaContasAPagarState extends State<TelaContasAPagar> {
  int _sortColumnIndex;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  bool _isLoading = false;
  bool _sortAscending = true;

  List<Conta> contas = <Conta>[];

  ContasDataSource _ordersDataSource;

  TextEditingController editingController = TextEditingController();
  TextEditingController filtroRangeController = new TextEditingController();

  void _sort<T>(Comparable<T> getField(Conta d), int columnIndex,
      bool ascending) {
    _ordersDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void initState() {
    super.initState();
    DocumentReference doc = FirebaseFirestore.instance.doc('firestore-example-app');
    contas = <Conta>[];
    buildTabelaContas(true);
  }

  @override
  Widget build(BuildContext context) {
    _ordersDataSource = new ContasDataSource(contas, context);
    return Container(
        margin: EdgeInsets.only(top: 12),
        child: Column(children: <Widget>[
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width - 100,
            child: SingleChildScrollView(
                child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20.0),
                    children: <Widget>[contasPaginatedDataTable()])),
          ),
        ]));
  }

  Widget contasPaginatedDataTable() {
    return !_isLoading ? content() : Center(child: CircularProgressIndicator());
  }

  content() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: tabelaContas(),
        ),
        Column(
          children: <Widget>[
            painelValorTotalAPagar(),
            SizedBox(
              height: 20,
            ),
            painelValorTotalAReceber(),
            SizedBox(
              height: 20,
            ),
            painelValorTotalAAbatido()
          ],
        )
      ],
    );
  }


  Widget summary(BuildContext context, String text, double amount) =>
      Padding(
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Column(
          children: <Widget>[
            Text(
              text,
              style: Theme
                  .of(context)
                  .textTheme
                  .body1
                  .copyWith(
                  fontSize: 14.0
              ),
            ),
            Text(
              amount.toStringAsFixed(2),
              style: Theme
                  .of(context)
                  .textTheme
                  .body1,
            ),
          ],
        ),
      );

  IntrinsicHeight painelValorTotalAPagar() {
    return IntrinsicHeight(
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          CardTile(
            iconBgColor: Colors.deepOrange,
            cardTitle: 'Total a Pagar',
            icon: Icons.attach_money,
            subText: 'Mês de Abril',
            mainText: contas
                ?.map<double>((c) => c.valor)
                .reduce((a, b) => a + b)
                .toString(),
          ),
        ]));
  }

  IntrinsicHeight painelValorTotalAReceber() {
    return IntrinsicHeight(
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          CardTile(
            iconBgColor: Colors.blue,
            cardTitle: 'A Receber',
            icon: Icons.attach_money,
            subText: 'Mês de Abril',
            mainText: 50.toString(),
          ),
        ]));
  }

  IntrinsicHeight painelValorTotalAAbatido() {
    var total =
        contas?.map<double>((c) => c.valor).reduce((a, b) => (a + b)) - 50;
    return IntrinsicHeight(
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          CardTile(
            iconBgColor: Colors.orange,
            cardTitle: 'Valor Total',
            icon: Icons.attach_money,
            subText: 'Mês de Abril',
            mainText: total.toString(),
          ),
        ]));
  }

  Container tabelaContas() {
    return Container(
        padding: EdgeInsets.only(left: 22, right: 22, bottom: 22),
        child: PaginatedDataTable(
          header: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              insereContaContaButton(),
              filtro(),
          Container(
            padding: EdgeInsets.all(
                10),
            width: 230,
            child: GestureDetector(
                onTap: () => _filterRangeDate(),
                child: AbsorbPointer(
                  child: _customTextFormField("Range de data",
                      filtroRangeController,
                      true, null),
                )
            )
          ),

            ],
          ),
          rowsPerPage: _rowsPerPage,
          onRowsPerPageChanged: (int value) {
            setState(() {
              _rowsPerPage = value;
              contas.clear();
              buildTabelaContas(true);
            });
          },
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          onPageChanged: (value) {
            setState(() {
              buildTabelaContas(false);
            });
          },
          columns: _orderDataTableColumns(),
          source: _ordersDataSource,
        ));
  }

  TextFormField _customTextFormField(String name,
      TextEditingController controller,
      bool isRequired, Function setValueField,
      {bool isEnable = true, inputFormatters}) {
    return new TextFormField(
      key: Key(name),
      controller: controller,
      enabled: isEnable,
      keyboardType: TextInputType.text,
      inputFormatters: inputFormatters != null ? inputFormatters : null,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
        ),
        labelText: "${name}",
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
      validator: (val) {
        if (isRequired) {
          return val.isEmpty ? 'O campo $name não pode estar vazio.' : null;
        }
        return null;
      },
      onSaved: (val) {
        //setValueField(val);
      },
    );
  }

  filtro() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(10),
              width: 400,
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Filtrar",
                    hintText: "Pesquise por numero do Documento",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ))
        ]);
    ;
  }

  var items = List<Conta>();

  void filterSearchResults(String query) {
    List<Conta> dummySearchList = List<Conta>();
    dummySearchList.addAll(contas);
    if (query.isNotEmpty) {
      List<Conta> dummyListData = List<Conta>();
      dummySearchList.forEach((item) {
        if (item.numDocumento.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        contas.clear();
        contas.addAll(dummyListData);
      });
      return;
    }
  }

  _orderDataTableColumns() {
    return <DataColumn>[
      DataColumn(
        label: const Text('Cód. da Conta'),
        numeric: true,
        onSort: (int columnIndex, bool ascending) =>
            _sort<num>((Conta c) => c.id, columnIndex, ascending),
      ),
      DataColumn(label: const Text('Numero do Documento'), numeric: true),
      DataColumn(
        label: const Text('Data da Emissão'),
        onSort: (int columnIndex, bool ascending) =>
            _sort<String>(
                    (Conta d) => formatterDate.format(d.dataEmissao),
                columnIndex,
                ascending),
      ),
      DataColumn(
        label: const Text('Data do Vencimento'),
        onSort: (int columnIndex, bool ascending) =>
            _sort<String>(
                    (Conta d) => formatterDate.format(d.dataVencimento),
                columnIndex,
                ascending),
      ),
      DataColumn(label: const Text('Valor')),
      DataColumn(label: const Text('Juros')),
      DataColumn(label: const Text('Desconto')),
      DataColumn(
        label: const Text('Status'),
        onSort: (int columnIndex, bool ascending) =>
            _sort<String>((Conta d) => d.status, columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Conta Origem'),
        onSort: (int columnIndex, bool ascending) =>
            _sort<String>(
                    (Conta d) => d.contaOrigem?.nome, columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Fornecedor'),
        onSort: (int columnIndex, bool ascending) =>
            _sort<String>(
                    (Conta d) => d.fornecedor?.nome, columnIndex, ascending),
      ),
      DataColumn(label: const Text('Forma de Pagamento')),
      DataColumn(label: const Text('Tipo de Conta')),
      DataColumn(
        label: const Text('Descrição'),
        onSort: (int columnIndex, bool ascending) =>
            _sort<String>((Conta d) => d.descricao, columnIndex, ascending),
      )
    ];
  }

  Future<Null> buildTabelaContas(bool showLoading) async {
    if (!_isLoading) {
      setState(() {
        _isLoading = showLoading;
      });

      addItem(Conta(
          id: 1,
          dataEmissao: DateTime.now(),
          dataVencimento: DateTime.now(),
          valor: 200,
          juros: 0,
          desconto: 0,
          parcelas: 1,
          formaPagamento: "Cartão de Crédito",
          tipoConta: "Agua e Esgoto",
          status: "Em Aberto",
          numDocumento: "33200433041260048604550000009896101121029006",
          contaOrigem: Empresa(id: 2, nome: "Acop Files"),
          fornecedor: Empresa(id: 1, nome: "Fornecedor 1")));

      setState(() {
        _isLoading = false;
      });
    }
  }

  void addItem(Conta conta) {
    setState(() {
      conta.id = contas.length + 1;
      contas.add(conta);
      contas.sort((a, b) {
        return b.id.compareTo(a.id);
      });
    });
  }

  insereContaContaButton() {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(0.0),
              side: BorderSide(color: drawerBgColor)),
          color: drawerBgColor,
          onPressed: () {
            setState(() {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: SizedBox(
                          height: 55,
                          child: AppBar(
                            elevation: 4,
                            centerTitle: true,
                            title: Text(
                              'Inserir Conta',
                            ),
                            backgroundColor: drawerBgColor,
                          ),
                        ),
                        content: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width / 1.8,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height / 1.4,
                            child: new NovaContaContent(addItem)));
                  });
            });
          },
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Icon(Icons.playlist_add, color: Colors.white),
              SizedBox(
                width: 10,
              ),
              new Text('Inserir Conta', style: TextStyle(color: Colors.white)),
            ],
          ),
        ));
  }

  Future<Null> _filterRangeDate() async {
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: new DateTime.now(),
        initialLastDate: (new DateTime.now()).add(new Duration(days: 7)),
        firstDate: new DateTime(2015),
        lastDate: new DateTime(2021)
    );
    if (picked != null && picked.length == 2) {
      List<Conta> dummySearchList = List<Conta>();
      dummySearchList.addAll(contas);
      List<Conta> dummyListData = List<Conta>();
      dummySearchList.forEach((item) {
        if (item.dataVencimento.isAfter(picked[0])
            && item.dataVencimento.isBefore(picked[1])) {
          dummyListData.add(item);
          setState(() {
            contas.clear();
            contas.addAll(dummyListData);
          });
        }
      });
    }
  }
}