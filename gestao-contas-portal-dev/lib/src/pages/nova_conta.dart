import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_dashboard/src/commons/theme.dart';
import 'package:flutter_web_dashboard/src/model/conta.dart';
import 'package:flutter_web_dashboard/src/model/converters/CustomDateTimeConverter.dart';
import 'package:flutter_web_dashboard/src/model/empresa.dart';
import 'package:flutter_web_dashboard/src/model/formmatters/currency_input_formatter.dart';
import 'package:flutter_web_dashboard/src/pages/month_picker.dart' as picker;
import 'package:intl/date_symbol_data_local.dart';

class NovaContaContent extends StatefulWidget {
  NovaContaContent(
      this.adicionaItem,
      {Key key}
      ): super(key: key);

  final Function adicionaItem;

  @override
  _NovaContaContentState createState() => new _NovaContaContentState();
}

class _NovaContaContentState extends State<NovaContaContent> {

  Conta conta = null;

  TextEditingController dataEmissaoController = new TextEditingController();
  TextEditingController dataCompetenciaController = new TextEditingController();
  TextEditingController dataVencimentoController = new TextEditingController();
  TextEditingController dataPagamentoController = new TextEditingController();

  TextEditingController descricaoController = new TextEditingController();
  TextEditingController valorParceladoController = new TextEditingController();
  TextEditingController observacoesController = new TextEditingController();
  TextEditingController parcelasController = new TextEditingController(text: "1");
  TextEditingController statusController = new TextEditingController();
  TextEditingController numDocumentoController = new TextEditingController();

  TextEditingController tipoContaController = new TextEditingController();
  TextEditingController formaPagamentoController = new TextEditingController();
  TextEditingController valorController = new TextEditingController(text: "R\u0024 0,00");
  TextEditingController descontoController = new TextEditingController(text: "R\u0024 0,00");
  TextEditingController jurosController = new TextEditingController(text: "R\u0024 0,00");

  TextEditingController contaOrigemController = new TextEditingController();
  TextEditingController fornecedorController = new TextEditingController();

  DateTime dataEmissao = new DateTime.now();
  DateTime dataCompetencia = new DateTime.now();
  DateTime dataVencimento = new DateTime.now();
  DateTime dataPagamento = new DateTime.now();

  static final _updateFormKey = new GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();

    initDateLocale();

    conta = new Conta();
  }

  Future<void> initDateLocale() async {
    await initializeDateFormatting("pt_BR", null);
  }

  _getContent(){
    return Column(
        children: <Widget>[
          new Expanded(
            child: SingleChildScrollView(
                child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Form(
                        key: _updateFormKey,
                        child: Container(
                            padding: EdgeInsets.all(15),
                            child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: <Widget>[
                                  _sectionInformationCard(cadastroNovaContaContent())
                                ]))))
            ),
          ),
          Container(
            height: 2,
            padding: EdgeInsets.only(top: 10),
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 1, // has the effect of softening the shadow
                  spreadRadius: 1, // has the effect of extending the shadow
                  offset: Offset(
                    1, // horizontal, move right 10
                    1, // vertical, move down 10
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                inserirButton()
              ],
            ),
          ),
        ]);
  }

  Padding cadastroNovaContaContent() {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(
                        10),
                    width: 230,
                    child: GestureDetector(
                        onTap:()=> _selectDate(dataEmissao, dataEmissaoController),
                        child: AbsorbPointer(
                          child: _customTextFormField("Data da Emissão",
                              dataEmissaoController,
                              true, setValueFieldDataEmissao),
                        )
                    )),
                Container(
                    padding: EdgeInsets.all(
                        10),
                    width: 230,
                    child: GestureDetector(
                        onTap:()=> showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return new picker.MonthPicker();
                            }),
                        child: AbsorbPointer(
                          child: _customTextFormField("Data da Competência",
                              dataCompetenciaController,
                              true, setValueFieldDataCompetencia),
                        )
                    )),
                Container(
                    padding: EdgeInsets.all(
                        10),
                    width: 230,
                    child: GestureDetector(
                        onTap:()=> _selectDate(dataVencimento, dataVencimentoController),
                        child: AbsorbPointer(
                          child: _customTextFormField("Data do Vencimento",
                              dataVencimentoController,
                              true, setValueFieldDataVencimento),
                        )
                    ))
              ],
            ),
            Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(
                          10),
                      width: 310,
                      child: ContaOrigemCombo()),
                  Container(
                      padding: EdgeInsets.all(
                          10),
                      width: 310,
                      child: FornecedorCombo())
                ]),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(10),
                    width: 150,
                    child: _customTextFormField(
                        "Parcelas", parcelasController,
                        true,
                        setValueFieldParcelas,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly])),
                Container(
                    padding: EdgeInsets
                        .all(10),
                    width: 180,
                    child: _customTextFormField("Valor",
                        valorController,
                        false, setValueFieldValor,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, CurrencyInputFormatter()])),
                Container(
                    padding: EdgeInsets
                        .all(10),
                    width: 180,
                    child: _customTextFormField("Desconto",
                        descontoController,
                        false, setValueFieldDesconto,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, CurrencyInputFormatter()])),
                Container(
                    padding: EdgeInsets
                        .all(10),
                    width: 180,
                    child: _customTextFormField("Juros",
                        jurosController,
                        false, setValueFieldJuros,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, CurrencyInputFormatter()]))
              ],
            ),
            Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets
                          .all(10),
                      width: 210,
                      child: tipoContaDropdown()),
                  Container(
                      padding: EdgeInsets
                          .all(10),
                      width: 260,
                      child: formaPagamentoDropdown()),
                  Container(
                      padding: EdgeInsets
                          .all(10),
                      width: 220,
                      child: statusDropdown())
                ]),
            Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets
                          .all(10),
                      width: 500,
                      child: _customTextFormField(
                          "Número do Documento",
                          numDocumentoController,
                          true, setValueFieldNumDocumento,
                          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly])),
                ]),
            Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets
                          .all(10),
                      width: 500,
                      child: _customTextFormField(
                          "Descrição",
                          descricaoController,
                          false, setValueFieldDescricao)),
                ])
          ],));
  }

  Future<Null> _selectDate(DateTime data, TextEditingController controller) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dataVencimento,
        firstDate: DateTime.now().subtract(new Duration(days: 90)),
        lastDate: DateTime.now().add(new Duration(days: 10)));
    if (picked != null && picked != dataVencimento)
      setState(() {
        data = picked;
        controller.value = TextEditingValue(text: formatterDate.format(picked));
      });
  }

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }

  Card _sectionInformationCard(Widget content) {
    return Card(
        margin: EdgeInsets.only(bottom: 10),
        color: Colors.white,
        child: content
    );
  }

  Container inserirButton() {
    return Container(
        height: 50,
        padding: EdgeInsets.all(5),
        child: RaisedButton(
            color: drawerBgColor,
            onPressed: () async {
              final form = _updateFormKey.currentState;
              if (form.validate()) {
                setState(() {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(child: CircularProgressIndicator());
                      });
                });
                form.save();
                Navigator.pop(context);
                Navigator.of(context).pop();
                widget.adicionaItem(conta);
              }
              },
            child: Text(
              'Salvar',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )));
  }

  Container cancelarButton() {
    return Container(
        height: 50,
        padding: EdgeInsets.all(5),
        child: RaisedButton(
            color: drawerBgColor,
            onPressed: () async {
              Navigator.pop(context);
            },
            child: Text(
              'Cancelar',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )));
  }

  ContaOrigemCombo() {
    List<Empresa> contaOrigem = [Empresa(nome: 'Avante Adminstradora'), Empresa(nome: 'Associação dos Advogados'), Empresa(nome: 'Acop Files')];

    return ListTile(
        dense: true,
        title:
        Text("Conta origem", style: TextStyle(color: Colors.grey, fontSize: 12)),
        subtitle: DropdownButton(
          hint: new SizedBox(
              width: MediaQuery.of(context).size.width / 7,
              child: new Text('${conta.contaOrigem?.nome ?? 'Escolha uma conta origem'}',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start)),
          items: contaOrigem
              .map<DropdownMenuItem<String>>((Empresa value) {
            return DropdownMenuItem<String>(
              value: value.nome,
              child: Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width / 8.5,
                  child: Text('${value.nome}',
                      style: TextStyle(
                        color: Color(0xFF4F4F51),
                        fontSize: 14.0,
                      ))),
            );
          }).toList(),
          onChanged: (String value) {
            setState(() {
              conta.contaOrigem =
                  contaOrigem.singleWhere((map) => map.nome == value);
            });
          },
        ));
  }

  FornecedorCombo() {
    List<Empresa> fornecedores = [Empresa(nome: 'Fornecedor 1'), Empresa(nome: 'Fornecedor 2'), Empresa(nome: 'Fornecedor 3'), Empresa(nome: 'Fornecedor 4')];

    return ListTile(
        dense: true,
        title:
        Text("Fornecedor", style: TextStyle(color: Colors.grey, fontSize: 12)),
        subtitle: DropdownButton(
          hint: new SizedBox(
              width: MediaQuery.of(context).size.width / 7,
              child: new Text('${conta.fornecedor?.nome ?? 'Escolha um fornecedor'}',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start)),
          items: fornecedores
              .map<DropdownMenuItem<String>>((Empresa value) {
            return DropdownMenuItem<String>(
              value: value.nome,
              child: Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width / 8.5,
                  child: Text('${value.nome}',
                      style: TextStyle(
                        color: Color(0xFF4F4F51),
                        fontSize: 14.0,
                      ))),
            );
          }).toList(),
          onChanged: (String value) {
            setState(() {
              conta.fornecedor =
                  fornecedores.singleWhere((map) => map.nome == value);
            });
          },
        ));
  }

  ListTile statusDropdown() {
    List<String> status = ['Pago', 'Em Aberto', 'Vencido', 'Cancelado'];
    var name = conta.status;

    return ListTile(
        dense: true,
        title:
        Text("Status", style: TextStyle(color: Colors.grey, fontSize: 12)),
        subtitle: new DropdownButton<String>(
          hint: Text("..."),
          items: status.map((String nome) {
            return new DropdownMenuItem<String>(
              value: nome,
              child: new Text(nome),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                conta.status = value;
              });
            }
          },
          value: name,
        ));
  }

  ListTile tipoContaDropdown() {
    List<String> tipoConta = ['Agua e Esgoto', 'Luz', 'Aluguel', 'Fornecedor'];
    var name = conta.tipoConta;

    return ListTile(
        dense: true,
        title:
        Text("Tipo de Conta", style: TextStyle(color: Colors.grey, fontSize: 12)),
        subtitle: new DropdownButton<String>(
          hint: Text("...", textAlign: TextAlign.end),
          items: tipoConta.map((String nome) {
            return new DropdownMenuItem<String>(
              value: nome,
              child: new Text(nome),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                conta.tipoConta = value;
              });
            }
          },
          value: name,
        ));
  }

  ListTile formaPagamentoDropdown() {
    List<String> status = ['Cartão de Crédito', 'Cartão de Débito', 'Boleto', 'Transferência Bancária', 'Dinheiro'];
    var name = conta.formaPagamento;

    return ListTile(
        dense: true,
        title:
        Text("Forma de Pagamento", style: TextStyle(color: Colors.grey, fontSize: 12)),
        subtitle: new DropdownButton<String>(
          hint: Text("..."),
          items: status.map((String nome) {
            return new DropdownMenuItem<String>(
              value: nome,
              child: new Text(nome),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                conta.formaPagamento = value;
              });
            }
          },
          value: name,
        ));
  }

  setValueFieldDataEmissao(String value) => setState(() {
    var split = value.split("/");
    conta.dataEmissao = new DateTime(int.parse(split[2]), int.parse(split[1]), int.parse(split[0]));
  });
  setValueFieldDataCompetencia(String value) => setState(() {
    var split = value.split("/");
    conta.dataCompetencia = new DateTime(int.parse(split[2]), int.parse(split[1]), int.parse(split[0]));
  });
  setValueFieldDataVencimento(String value) => setState(() {
    var split = value.split("/");
    conta.dataVencimento = new DateTime(int.parse(split[2]), int.parse(split[1]), int.parse(split[0]));
  });
  setValueFieldDataPagamento(String value) => setState(() {
    var split = value.split("/");
    conta.dataPagamento = new DateTime(int.parse(split[2]), int.parse(split[1]), int.parse(split[0]));
  });

  setValueFieldParcelas(var value) => setState(() { conta.parcelas = int.parse(value); });

  setValueFieldValor(String value) => setState(() {
    var valor = value.replaceRange(0, 3, "").replaceAll(".", "").replaceAll(",", ".");
    conta.valor = double.parse(valor);
  });
  setValueFieldJuros(String value) => setState(() {
    var valor = value.replaceRange(0, 3, "").replaceAll(".", "").replaceAll(",", ".");
    conta.juros = double.parse(valor);
  });
  setValueFieldDesconto(String value) => setState(() {
    var valor = value.replaceRange(0, 3, "").replaceAll(".", "").replaceAll(",", ".");
    conta.desconto = double.parse(valor);
  });

  setValueFieldTipoConta(var value) => setState(() { conta.tipoConta = value; });
  setValueFieldDescricao(var value) => setState(() { conta.descricao = value; });
  setValueFieldObservacoes(var value) => setState(() { conta.observacoes = value; });
  setValueFieldFormaPagamento(var value) => setState(() { conta.formaPagamento = value; });
  setValueFieldStatus(var value) => setState(() { conta.status = value; });
  setValueFieldNumDocumento(var value) => setState(() { conta.numDocumento = value; });

  setValueFieldContaOrigem(var value) => setState(() { conta.contaOrigem = Empresa(nome: value); });
  setValueFieldFornecedor(var value) => setState(() { conta.fornecedor = Empresa(nome: value); });

  TextFormField _customTextFormField(String name, TextEditingController controller,
      bool isRequired, Function setValueField, {bool isEnable = true, inputFormatters}) {
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
        setValueField(val);
      },
    );
  }
}