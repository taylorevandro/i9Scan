import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:scan/screen/empresa.dart';
import 'package:scan/screen/scanner.dart';
import 'package:scan/screen/upload_arq.dart';
import 'package:permission_handler/permission_handler.dart';

class produto extends StatefulWidget {
  const produto({Key? key}) : super(key: key);

  @override
  State<produto> createState() => _produtoState();
}

class _produtoState extends State<produto> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int conta = 0;
  int cur = 0;
  late List<List<dynamic>> produtData;
  List<dynamic> row = List.empty(growable: true);
  //final listItems = List<String>.generate(10000, (i) => "Item $i");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DataHelper.instance.database;
    atual();
  }

  void atual() async {
    conta = await DataHelper.instance.recordLP();
    setState(() {
      cur = conta;
    });
  }

  getCSV() async {
    List<Map> listprod;

    listprod = DataHelper.instance.queryall();

    listprod.forEach((element) {
      row.add(element.values);
      row.add(element.values);
      row.add(element.values);
      produtData.add(row);
    });

    if (await Permission.storage.request().isGranted) {
//store file in documents folder

      String dir = (await getExternalStorageDirectory())!.path + "/mycsv.csv";
      String file = "$dir";

      File f = new File(file);

// convert rows to String and write as csv file

      String csv = const ListToCsvConverter().convert(produtData);
      f.writeAsString(csv);
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: AppBar(
          //centerTitle: true,
          leading: IconButton(
            onPressed: () => _key.currentState!.openDrawer(),
            icon: Icon(Icons.menu),
            color: Color(0xFF01006E),
          ),
          backgroundColor: Color(0xFFE0E0FF),
          title: Text(
            'Lista de Produtos',
            style: TextStyle(color: Color(0xFF01006E)),
          ),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              width: 70,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 193, 193, 245),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 3,
                    ),
                    const Text('Total:',
                        style: TextStyle(color: Color(0xFF01006E))),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      cur.toString(),
                      style: const TextStyle(color: Color(0xFF01006E)),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.file_download,
                size: 34,
                color: Colors.black,
              ),
              onPressed: getCSV,
            )
          ],
        ),
        drawer: menu(context),
        body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(children: [
              Expanded(
                child: Center(
                  child: FutureBuilder<List<ListProdutos>>(
                    future: DataHelper.instance.getListProdutos(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ListProdutos>> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.blue),
                        );
                      }
                      return snapshot.data!.isEmpty
                          ? Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.do_not_disturb_off,
                                    size: 60,
                                  ),
                                  Text('Nenhum produto na lista.')
                                ],
                              ),
                            )
                          : ListView(
                              children: snapshot.data!.map((produto) {
                                return Card(
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons
                                            .check_box_outline_blank_rounded),
                                        title: Text(produto.codigo),
                                        subtitle: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Item: ${produto.descricao}'),
                                            Text('EAN: ${produto.ean}'),
                                            Text('Qtde: ${produto.qtde}')
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                    },
                  ),
                ),
              )
            ])));
  }

  Widget menu(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFFFFFBFE),
      child: ListView(
        //padding: EdgeInsets.zero,
        children: [
          ListTile(
            title: Text("i9 Scan",
                style: TextStyle(fontSize: 16, color: Color(0xFF01006E))),
          ),
          ListTile(
              leading: Icon(Icons.business),
              iconColor: Color(0xFF01006E),
              title: Text("Empresa",
                  style: TextStyle(fontSize: 14, color: Color(0xFF01006E))),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new Empresas(title: 'Empresas')),
                );
              }),
          ListTile(
              leading: Icon(Icons.qr_code),
              iconColor: Color(0xFF01006E),
              title: Text("Scanner",
                  style: TextStyle(fontSize: 14, color: Color(0xFF01006E))),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => scanner(
                            codigo: '',
                            nome: '',
                          )),
                );
              }),
          ListTile(
              leading: Icon(Icons.text_snippet),
              iconColor: Color(0xFF01006E),
              title: Text("Lista de Produtos",
                  style: TextStyle(fontSize: 14, color: Color(0xFF01006E))),
              selectedTileColor: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new produto()),
                );
              }),
          ListTile(
              leading: Icon(Icons.upload_file),
              iconColor: Color(0xFF01006E),
              title: Text("Upload de arquivos",
                  style: TextStyle(fontSize: 14, color: Color(0xFF01006E))),
              selectedTileColor: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new MyHomePage()),
                );
              }),
        ],
      ),
    );
  }
}

class ListProdutos {
  final int? id;
  final String codigo;
  final String descricao;
  // final String local;
  final String ean;
  final String rua;
  final String coluna;
  final String linha;
  final String qtde;

  ListProdutos(
      {this.id,
      required this.codigo,
      required this.descricao,
      //  required this.local,
      required this.ean,
      required this.rua,
      required this.coluna,
      required this.linha,
      required this.qtde});

  factory ListProdutos.fromMap(Map<String, dynamic> json) => new ListProdutos(
      id: json['id'],
      codigo: json['codigo'],
      descricao: json['descricao'],
      //    local: json['local'],
      ean: json['ean'],
      rua: json['rua'],
      coluna: json['coluna'],
      linha: json['linha'],
      qtde: json['qtde']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codigo': codigo,
      'descricao': descricao,
      'ean': ean,
      'rua': rua,
      'coluna': coluna,
      'linha': linha,
      'qtde': qtde
    };
  }
}

class DataHelper {
  int countr = 0;
  DataHelper._privateConstrutor();
  static final DataHelper instance = DataHelper._privateConstrutor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'i9scanf.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
                CREATE TABLE produtocheck(
                  id INTEGER PRIMARY KEY,
                  codigo TEXT,
                  descricao TEXT,
                  ean TEXT,
                  rua TEXT,
                  coluna TEXT,
                  linha TEXT, 
                  qtde TEXT
                )
                ''');
  }

  Future<List<ListProdutos>> getListProdutos() async {
    Database db = await instance.database;
    var produtos = await db.query('produtocheck', orderBy: 'id');
    List<ListProdutos> produtoList = produtos.isNotEmpty
        ? produtos.map((c) => ListProdutos.fromMap(c)).toList()
        : [];
    // print('tamanho no banco: ${produtoList.length}');
    return produtoList;
  }

  Future<int> add(ListProdutos listProdutos) async {
    Database db = await instance.database;
    return await db.insert('produtocheck', listProdutos.toMap());
  }

  queryall() async {
    Database db = await instance.database;
    List<Map> produt = await db.query('produtocheck');
    return produt;
  }

  Future<int> recordLP() async {
    Database db = await instance.database;
    countr = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM produtocheck'))!;
    // print(countr.toString());
    return countr;
  }
}
