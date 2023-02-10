import 'package:flutter/material.dart';
import 'package:scan/screen/produtos.dart';
import 'package:scan/screen/scanner.dart';

import 'package:scan/screen/upload_arq.dart';

class Empresas extends StatefulWidget {
  const Empresas({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Empresas> createState() => _EmpresasState();
}

enum SingingCharacter { lafayette, jefferson }

class _EmpresasState extends State<Empresas> {
  bool _lightIsOn = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () => _key.currentState!.openDrawer(),
            icon: const Icon(Icons.menu),
            color: const Color(0xFF01006E),
          ),
          backgroundColor: const Color(0xFFE0E0FF),
          title: Text(
            widget.title,
            style: const TextStyle(color: Color(0xFF01006E)),
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
        body: ListView(
          children: [
            GestureDetector(
              onTap: (() {
                setState(() {
                  // Toggle light when tapped.
                  _lightIsOn = !_lightIsOn;
                });
              }),
              child: Column(children: [
                card(context, 'i9 AMAZON', '123.123.432/5000.12'),
                //card(context, 'i9 AMAZON2', '222.123.432/5000.10'),
              ]),
            )
          ],
        ));
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
                Navigator.pop(context);
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

  Widget card(BuildContext context, String nome, String cnpj) {
    return Card(
      color: const Color(0xFFE0E0FF),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _lightIsOn
                            ? Icons.check_circle_sharp
                            : Icons.check_circle_outline,
                        size: 24,
                      ),
                      Text(' Empresa: '),
                      Expanded(
                        child: Text(
                          '$nome',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                      ),
                      Text(' CNPJ: '),
                      Text(
                        '$cnpj',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  child: Image.asset('images/i9amazon.jpg'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
