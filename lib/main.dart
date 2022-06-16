import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loaded = false;
  var children = <Widget>[
    Center(
      child: CircularProgressIndicator.adaptive(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      loadDat();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Zigg task 0"),
        ),
        body: ListView(
          children: children,
        ));
  }

  void loadDat() {
    log("lllll");
    var res = http.get(Uri.parse("https://api.getzigg.com/circle/my-circles"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'access-token': '[TOKEN]'
        });
    res.then((val) async {
      print('${val.body}');
      var json = jsonDecode(val.body);
      print('${json[0]}');
      var lis = <Widget>[];
      for (var item in json) {
        lis.add(Center(
            child: Container(
                constraints: BoxConstraints(maxWidth: 400),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        child: Container(
                          foregroundDecoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Color.fromARGB(255, 103, 103, 103)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.9, 1],
                            ),
                          ),
                          child: Image.network(item["displayPicture"],
                              fit: BoxFit.cover),
                          constraints:
                              BoxConstraints(maxHeight: 300, maxWidth: 400),
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0)),
                      ),
                      ClipRRect(
                        child: Container(
                          child: ListTile(
                            title: Text(item["name"]),
                            subtitle: Text(item["customID"]),
                          ),
                          color: Color.fromARGB(255, 103, 103, 103),
                        ),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0)),
                      )
                    ]))));
      }
      setState(() {
        loaded = true;
        children = lis;
      });
    }).catchError((err) {
      print('$err');
    });
  }
}
