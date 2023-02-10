import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scan/screen/login.dart';
import 'package:scan/screen/upload_arq.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    /*Timer(
        const Duration(seconds: 2),
        () => Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => loginpage())));
    */
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF9FA3FF),
          //Gradient
        ),
        //color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/logo.png',
              width: 250,
              height: 250,
            ),
            Column(
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    fixedSize: const Size(200, 45),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => loginpage()));
                  },
                  icon: const Icon(
                    Icons.login,
                    size: 18,
                    color: Color(0xFF01006E),
                  ),
                  label: const Text(
                    "Login",
                    style: TextStyle(fontSize: 18, color: Color(0xFF01006E)),
                  ),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    fixedSize: const Size(200, 45),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const MyHomePage()));
                  },
                  icon: const Icon(
                    Icons.logout,
                    size: 18,
                    color: Color(0xFF01006E),
                  ),
                  label: const Text("Sem acesso",
                      style: TextStyle(fontSize: 18, color: Color(0xFF01006E))),
                ),
              ],
            ),
            const Text(
              "I9Scan",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
