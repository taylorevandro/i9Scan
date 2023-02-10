import 'package:flutter/material.dart';
import 'package:scan/screen/empresa.dart';
import 'package:scan/screen/produtos.dart';
import 'package:scan/screen/scanner.dart';
import 'package:scan/screen/upload_arq.dart';

class LocalizacaoScreen extends StatefulWidget {
  int idProduto;
  String nome;
  String codigo;
  String ean;
  String rua;
  String coluna;
  // String local;
  String linha;
  LocalizacaoScreen({
    Key? key,
    required this.idProduto,
    required this.nome,
    required this.codigo,
    required this.rua,
    required this.coluna,
    required this.ean,
    required this.linha,
    // required this.local
  }) : super(key: key);

  @override
  State<LocalizacaoScreen> createState() => _LocalizacaoScreenState();
}

class _LocalizacaoScreenState extends State<LocalizacaoScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  late TextEditingController _qtde;

  @override
  // ignore: must_call_super
  void initState() {
    _key = GlobalKey();
    _qtde = TextEditingController();
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
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              //color: Colors.grey,
              margin: const EdgeInsets.only(
                  left: 12, right: 12, top: 15, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    //color: Colors.green,
                    child: Column(
                      children: [
                        const ListTile(
                          title: Text('Categoria'),
                          subtitle: Text('...'),
                        ),
                        /*Image.asset(
                          'images/produto.jpg',
                          width: 250,
                          height: 250,
                        ),*/
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  const Text(
                    'Identificar Produto',
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Roboto',
                        color: Color(0xFF01006E)),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  TextFormField(
                    cursorColor: const Color(0xFF01006E),
                    initialValue: widget.nome,
                    //controller: _local,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                      //helperText: 'Helper text',
                      hintText: 'Nome',
                    ),
                  ),
                  TextFormField(
                    cursorColor: const Color(0xFF01006E),
                    initialValue: widget.ean,
                    //controller: ,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      labelText: 'Código de Barra',
                      border: OutlineInputBorder(),
                      //helperText: 'Helper text',
                      hintText: 'Código de Barra',
                    ),
                  ),
                  TextFormField(
                    cursorColor: const Color(0xFF01006E),
                    initialValue: widget.codigo,
                    //controller: ,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      labelText: 'Código',
                      border: OutlineInputBorder(),
                      //helperText: 'Helper text',
                      hintText: 'Código',
                    ),
                  ),
                  TextFormField(
                    cursorColor: const Color(0xFF01006E),
                    //initialValue: '',
                    controller: _qtde,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      labelText: 'Quantidade',
                      border: OutlineInputBorder(),
                      //helperText: 'Helper text',
                      hintText: 'Quantidade',
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const Empresas(
                                      title: 'Empresas',
                                    )),
                          );

                          DataHelper.instance.add(ListProdutos(
                              codigo: widget.codigo,
                              descricao: widget.nome,
                              //local: widget.local,
                              ean: widget.ean,
                              rua: widget.rua,
                              coluna: widget.coluna,
                              linha: widget.linha,
                              qtde: _qtde.text));
                          DatabaseHelper.instance.delet(widget.idProduto);
                        }, //scanBarcodeNormal(),
                        child: const Text(
                          "Salvar",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            );
          }),
        ),
      ),
    );
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
