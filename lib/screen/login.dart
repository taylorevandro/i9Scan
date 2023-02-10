import 'package:flutter/material.dart';
import 'package:scan/screen/empresa.dart';

class loginpage extends StatefulWidget {
  const loginpage({Key? key}) : super(key: key);

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  Map<String, String> usuarios = {'usuario': '123', 'senha': '123'};

  String usuario = "";
  String senha = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 80),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 40, left: 6),
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bem vindo ao I9Scan',
                          style:
                              TextStyle(fontSize: 45, color: Color(0xFF01006E)),
                        ),
                        Divider(
                          height: 20,
                          color: Colors.white,
                        ),
                        Text(
                          'Faça log in para utilizar as funções do aplicativo',
                          style: TextStyle(color: Color(0xFF01006E)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    //height: 45,
                    padding: EdgeInsets.only(top: 180, left: 16, right: 16),
                    child: TextFormField(
                      //cursorColor: Theme.of(context).cursorColor,
                      initialValue: '',
                      decoration: InputDecoration(
                        labelText: 'Email ou CPF',
                        border: OutlineInputBorder(),
                        //helperText: 'Helper text',
                        hintText: '',
                      ),
                    ),
                  ),
                  Container(
                    //width: MediaQuery.of(context).size.width / 1.2,
                    //height: 45,
                    margin: EdgeInsets.only(top: 32),
                    padding: EdgeInsets.only(left: 16, right: 16),

                    child: TextFormField(
                      //cursorColor: Theme.of(context).cursorColor,
                      initialValue: '',
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                        //helperText: 'Helper text',
                        hintText: '',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, right: 32),
                      child: Text(
                        'Esqueceu a Senha ?',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: TextButton.styleFrom(
                            fixedSize: const Size(360, 50),
                            backgroundColor: Color(0xFF8286EE),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40))),
                        onPressed: () => {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) => new Empresas(
                                      title: 'Empresas',
                                    )),
                          ),
                        },
                        child: Text(
                          "Entrar",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
