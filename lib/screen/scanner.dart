import 'dart:io';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:scan/screen/produtos.dart';
import 'package:scan/screen/empresa.dart';
import 'package:flutter/services.dart';
import 'package:scan/screen/localizacao.dart';
import 'package:scan/screen/upload_arq.dart';

class scanner extends StatefulWidget {
  String nome;
  String codigo;

  scanner({Key? key, required this.nome, required this.codigo})
      : super(key: key);

  @override
  State<scanner> createState() => _scannerState();
}

class _scannerState extends State<scanner> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  String local = '';
  String rua = '';
  String coluna = '';
  String linha = '';
  bool add = false;

  late TextEditingController _local;
  late TextEditingController _rua;
  late TextEditingController _coluna;
  late TextEditingController _linha;
  int idP = 0;
  String codigo = '';
  String nome = '';
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
    _key = GlobalKey();
    _local = TextEditingController();
    _rua = TextEditingController();
    _coluna = TextEditingController();
    _linha = TextEditingController();
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;

    List<Map> expected;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Sair', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if (barcodeScanRes.isNotEmpty) {
      setState(() {
        _scanBarcode = barcodeScanRes;
        //barcodeScanRes;
      });
      expected = await DatabaseHelper.instance.query(_scanBarcode);
      if (expected.isNotEmpty) {
        setState(() {
          expected.forEach((i) {
            idP = i['id'];
            codigo = i['codigo'];
            nome = i['descricao'];
          });
          add = true;
        });
      } else {
        setState(() {
          add = false;
        });
      }
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            key: _key,
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                onPressed: () => _key.currentState!.openDrawer(),
                icon: const Icon(Icons.menu),
                color: const Color(0xFF01006E),
              ),
              backgroundColor: const Color(0xFFE0E0FF),
              title: const Text(
                'Localização',
                style: TextStyle(color: Color(0xFF01006E)),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    size: 34,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    // do something
                  },
                )
              ],
            ),
            drawer: menu(),
            body: SingleChildScrollView(
              child: Builder(builder: (BuildContext context) {
                return Container(
                    //alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Inserir Localização',
                          style: TextStyle(
                              fontSize: 36,
                              fontFamily: 'Roboto',
                              color: Color(0xFF01006E)),
                        ),
                        const Text(
                          'Local (não obrigatório)',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              color: Color(0xFF01006E)),
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        TextFormField(
                          cursorColor: const Color(0xFF01006E),
                          //initialValue: '' ,
                          controller: _local,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            labelText: 'Local',
                            border: OutlineInputBorder(),
                            //helperText: 'Helper text',
                            hintText: 'Local',
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        const Text(
                          'Endereço',
                          style: TextStyle(
                              fontSize: 36,
                              fontFamily: 'Roboto',
                              color: Color(0xFF01006E)),
                        ),
                        const Text(
                          'Endereço (não obrigatório)',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              color: Color(0xFF01006E)),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          cursorColor: const Color(0xFF01006E),
                          //initialValue: '',
                          controller: _rua,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            labelText: 'Rua',
                            border: OutlineInputBorder(),
                            //helperText: 'Helper text',
                            hintText: 'Rua',
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          cursorColor: const Color(0xFF01006E),
                          //initialValue: '',
                          controller: _coluna,
                          maxLength: 20,
                          decoration: const InputDecoration(
                            labelText: 'Coluna',
                            border: OutlineInputBorder(),
                            //helperText: 'Helper text',
                            hintText: 'Coluna',
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          cursorColor: const Color(0xFF01006E),
                          //initialValue: '',
                          controller: _linha,
                          maxLength: 20,
                          decoration: const InputDecoration(
                            labelText: 'Linha',
                            border: OutlineInputBorder(),
                            //helperText: 'Helper text',
                            hintText: 'Linha',
                          ),
                        ),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: TextButton.styleFrom(
                                  fixedSize: const Size(360, 50),
                                  backgroundColor: const Color(0xFF8286EE),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40))),
                              onPressed: () async {
                                await scanBarcodeNormal();
                                if (add = true) {
                                  const snackBar = SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content:
                                        Text('Produto adicionado com sucesso!'),
                                  );

                                  // ignore: deprecated_member_use
                                  //Scaffold.of(context).showSnackBar(snackBar);
                                } else {
                                  const snackBar = SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text('Produuto não encontrado!'),
                                  );

                                  // ignore: deprecated_member_use
                                  //Scaffold.of(context).showSnackBar(snackBar);
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          LocalizacaoScreen(
                                            idProduto: idP,
                                            nome: nome,
                                            codigo: codigo,
                                            //local: local,
                                            rua: rua,
                                            linha: linha,
                                            coluna: coluna,
                                            ean: _scanBarcode,
                                          )),
                                );
                              }, //scanBarcodeNormal(),
                              child: const Text(
                                "Adicionar Produto",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        )),
                      ],
                    ));
              }),
            )));
  }

  Widget menu() {
    return Drawer(
      backgroundColor: const Color(0xFFFFFBFE),
      child: ListView(
        //padding: EdgeInsets.zero,
        children: [
          const ListTile(
            title: Text("i9 Scan",
                style: TextStyle(fontSize: 16, color: Color(0xFF01006E))),
          ),
          ListTile(
              leading: const Icon(Icons.business),
              iconColor: const Color(0xFF01006E),
              title: const Text("Empresa",
                  style: TextStyle(fontSize: 14, color: Color(0xFF01006E))),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const Empresas(title: 'Empresas')),
                );
              }),
          ListTile(
              leading: const Icon(Icons.qr_code),
              iconColor: Color(0xFF01006E),
              title: const Text("Scanner",
                  style: TextStyle(fontSize: 14, color: Color(0xFF01006E))),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => scanner(
                            codigo: '',
                            nome: '',
                          )),
                );
              }),
          ListTile(
              leading: const Icon(Icons.text_snippet),
              iconColor: const Color(0xFF01006E),
              title: const Text("Lista de Produtos",
                  style: TextStyle(fontSize: 14, color: Color(0xFF01006E))),
              selectedTileColor: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const produto()),
                );
              }),
        ],
      ),
    );
  }
}
