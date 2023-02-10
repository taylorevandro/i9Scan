// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:scan/screen/empresa.dart';
import 'package:scan/screen/produtos.dart';
import 'package:scan/screen/scanner.dart';
import 'package:scan/screen/localizacao.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final codigotextController = TextEditingController();
  final desctextController = TextEditingController();
  final eantextController = TextEditingController();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String contador = '';
  int conta = 0;
  int cur = 0;
  bool? click;
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    atual();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    //EasyLoading.showSuccess('Use in initState');
    // EasyLoading.removeCallbacks();
  }

  void atual() async {
    conta = await DatabaseHelper.instance.record();
    setState(() {
      cur = conta;
    });
  }

  Future<List<Produto>> atualiza = DatabaseHelper.instance.getProdutos();

  void recarregar() {
    initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
          //centerTitle: true,
          leading: IconButton(
            onPressed: () => _key.currentState!.openDrawer(),
            icon: const Icon(Icons.menu),
            color: const Color(0xFF01006E),
          ),
          backgroundColor: const Color(0xFFE0E0FF),
          title: const Text(
            'Upload de arquivos',
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
                onPressed: () => {
                      setState(() {
                        DatabaseHelper.instance.deletAll();
                      }),
                      atual(),
                    },
                icon: const Icon(
                  Icons.delete,
                  size: 28,
                  color: Colors.black,
                )),
          ]),
      drawer: menu(context),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          Expanded(
            child: Center(
              child: RefreshIndicator(
                onRefresh: () async {
                  await DatabaseHelper.instance.getProdutos();
                  setState(() {
                    atual();
                  });
                  return Future<void>.delayed(const Duration(seconds: 3));
                },
                child: FutureBuilder<List<Produto>>(
                  future: DatabaseHelper.instance.getProdutos(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Produto>> snapshot) {
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
                                      leading:
                                          const Icon(Icons.check_circle_sharp),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.qr_code),
                                        onPressed: () => showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text('Localização'),
                                            content: const Text(
                                                'Deseja informar a localização:?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {},
                                                /*onPressed: () => {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          LocalizacaoScreen(
                                                            nome: produto
                                                                .descricao
                                                                .toString(),
                                                            codigo: produto.codigo
                                                                .toString(),
                                                          )),
                                            )
                                          },*/
                                                child: const Text('NÂO'),
                                              ),
                                              TextButton(
                                                onPressed: () => {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            LocalizacaoScreen(
                                                          idProduto: 1,
                                                          nome: produto
                                                              .descricao
                                                              .toString(),
                                                          codigo: produto.codigo
                                                              .toString(),
                                                          rua: 'rua',
                                                          coluna: 'coluna',
                                                          ean: 'ean',
                                                          linha: 'linha',
                                                          // local: 'local'
                                                        ),
                                                      ))
                                                },
                                                child: const Text('SIM'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      title: Text(produto.codigo),
                                      subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Item: ${produto.descricao}'),
                                          Text('EAN: ${produto.ean}')
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
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE0E0FF),
        onPressed: () async {
          setState(() {
            click = true;
          });
          if (click = true) {
            /*_key.currentState!.showSnackBar(SnackBar(
                backgroundColor: Colors.black,
                // duration: Duration(minutes: 2),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text('Loading...'),
                    const SizedBox(width: 7),
                    const CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    )
                  ],
                )));*/
          }

          _loadData();

          //_key.currentState?.hideCurrentSnackBar();

          await DatabaseHelper.instance.getProdutos();

          setState(() {
            click = false;
          });
        },
        /*onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('insira itens'),
            content: Center(
                child: Column(
              children: [
                TextField(
                  controller: codigotextController,
                ),
                TextField(
                  controller: desctextController,
                ),
                TextField(
                  controller: eantextController,
                ),
              ],
            )),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  await DatabaseHelper.instance.add(Produto(
                      codigo: eantextController.text,
                      descricao: desctextController.text,
                      ean: eantextController.text));

                  setState(() {
                    codigotextController.clear();
                    desctextController.clear();
                    eantextController.clear();
                  });
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: const Color(0xFF01006E),
                  ),
                ),
              ),
            ],
          ),
        ),*/
        tooltip: 'Increment',
        child: const Icon(Icons.upload_file, color: Color(0xFF01006E)),
      ),
    );
  }

  Future<void> _loadData() async {
    //List<List<dynamic>> csv = [];
    List<String> listageral;
    //Stream<List<dynamic>> inputStream;
    String? filePath = r'/storage/emulated/';
    final result = await FilePicker.platform.pickFiles();
    filePath = result!.files.single.path;
    print('object sendo lido');
    //inputStream = File('${fileath}').openRead();

    var stringeral = File('${filePath}').readAsStringSync();

    listageral = stringeral.split("\n");
    print(listageral.length);
    EasyLoading.show(status: 'loading...');
    try {
      for (var element in listageral) {
        var spl = element.split(';');

        var codigo = spl[0].replaceAll(new RegExp(r'[^\w\s]+'), '');
        var Ean = spl[1].replaceAll(new RegExp(r'[^\w\s]+'), '');
        var descricao = spl[2].replaceAll(new RegExp(r'[^\w\s]+'), '');

        print("$codigo, $Ean, $descricao");

        await DatabaseHelper.instance.add(Produto(
            codigo: codigo.toString(),
            descricao: descricao,
            ean: Ean.toString()));
      }
    } catch (e) {
      print(e);
    }

    EasyLoading.showSuccess('Great Success!');
    atual();
    /*
    try {
      csv = await inputStream
          .transform(utf8.decoder)
          .transform(const CsvToListConverter(fieldDelimiter: ';'))
          .toList();
    } catch (e) {
      //showAlertDialog2(context);
      //showAlertDialog1(context);
      //throw Exception('Extensao de texto');
    
    }*/
    /* setState(() {
     listageral.forEach((linha) {
        var codigo = linha[0];
        var Ean = linha[1];
        var descricao = linha[2];
        DatabaseHelper.instance
            .add(Produto(codigo: codigo, descricao: descricao, ean: Ean));
      });
      

      contador = DatabaseHelper.instance.record().toString();
    });*/

    //print(csv.length);
  }

  Widget menu(BuildContext context) {
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
                      builder: (BuildContext context) => produto()),
                );
              }),
          ListTile(
              leading: const Icon(Icons.qr_code),
              iconColor: const Color(0xFF01006E),
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
          ListTile(
              leading: const Icon(Icons.upload_file),
              iconColor: const Color(0xFF01006E),
              title: const Text("Upload de arquivos",
                  style: TextStyle(fontSize: 14, color: Color(0xFF01006E))),
              selectedTileColor: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const MyHomePage()),
                );
              }),
        ],
      ),
    );
  }
}

class Produto {
  final int? id;
  final String codigo;
  final String descricao;
  final String ean;

  Produto(
      {this.id,
      required this.codigo,
      required this.descricao,
      required this.ean});

  factory Produto.fromMap(Map<String, dynamic> json) => new Produto(
      id: json['id'],
      codigo: json['codigo'],
      descricao: json['descricao'],
      ean: json['ean']);

  Map<String, dynamic> toMap() {
    return {'id': id, 'codigo': codigo, 'descricao': descricao, 'ean': ean};
  }
}

class DatabaseHelper {
  int countr = 0;
  DatabaseHelper._privateConstrutor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstrutor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'i9scan.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
                CREATE TABLE produtos(
                  id INTEGER PRIMARY KEY,
                  codigo TEXT,
                  descricao TEXT,
                  ean TEXT
                )
                ''');
  }

  Future<List<Produto>> getProdutos() async {
    Database db = await instance.database;
    var produtos = await db.query('produtos', orderBy: 'id');
    List<Produto> produtoList = produtos.isNotEmpty
        ? produtos.map((c) => Produto.fromMap(c)).toList()
        : [];
    // print('tamanho no banco: ${produtoList.length}');
    return produtoList;
  }

  Future<List<Produto>> getProdutoOnly(String codigo) async {
    Database db = await instance.database;
    var produt =
        await db.query('produtos', where: 'ean = ?', whereArgs: ['$codigo']);
    List<Produto> prod =
        produt.isNotEmpty ? produt.map((c) => Produto.fromMap(c)).toList() : [];

    return prod;
  }

  query(String codigo) async {
    Database db = await instance.database;
    List<Map> produt =
        await db.query('produtos', where: 'ean = ?', whereArgs: ['$codigo']);
    return produt;
  }

  Future<int> add(Produto produto) async {
    Database db = await instance.database;
    //var batch = db.batch();
    //batch.insert('produtos', produto.toMap());
    //int result = 1;
    //await db.batch().commit();
    return await db.insert('produtos', produto.toMap());
  }

  Future<int> delet(int id) async {
    Database db = await instance.database;
    return await db.delete('produtos', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deletAll() async {
    Database db = await instance.database;
    return await db.delete('produtos');
  }

  Future<int> record() async {
    Database db = await instance.database;
    countr = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM produtos'))!;
    // print(countr.toString());
    return countr;
  }
}
