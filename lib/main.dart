import 'dart:async';

import 'package:flutter/material.dart';


//main() => runApp(new MyApp());
import 'package:pub_client/pub_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Database.dart';
import 'DatabaseWrapper.dart';

void main() async{
  print("Starting");
  runApp(MyApp());
  print("Starting pubclient");
  var client = new PubClient();
  print("Starting app");
  Future<List<PackageClass>> packages = AppSerialization(Database()).readData();
  packages.then((onValue) {
    if (onValue == null) {
      print("Fetching data");
      Future<List<Package>> packages = client.getAllPackages();
      packages.then((onValue) async {
        AppSerialization(Database()).saveData(onValue);
        doStuff(package2packageClass(onValue));
      });
    } else {
      print("Data already fetched");
      doStuff(onValue);
    }
  });
}

  PackageClass package2packageClass(List<Package> package) {
    package.map((it) => it.toJson()).toList().map((it) => packageClassFromJson(it)).toList();
    return packageClassFromJson(package.toJson());
  }

 doStuff(List<PackageClass> packages) {
  PackageClass package = packages.toList().first;
  print(package.name);

  print(package.hashCode);
  print(".....");
  print(package.toJson());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'PackageWho',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.cyan,
      ),
        home: new MyHomePage(title: 'PackageWho'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;


  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Package> packages =  [];
  void _updateList() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: packages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${packages[index]}'),
          );
        },
      ),
    );
  }
}
