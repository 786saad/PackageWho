import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_who/mockDataBase.dart';

import 'package:url_launcher/url_launcher.dart';
//main() => runApp(new MyApp());
import 'package:pub_client/pub_client.dart';

import 'DatabaseWrapper.dart';

void main() async{
  print("Starting");
  runApp(MyApp());
 /* print("Starting pubclient");
  var client = new PubClient();
  print("Starting app");
  Future<List<Package>> packages = readData();
  packages.then((onValue) {
    if (onValue == null) {
      print("Fetching data");
      packages = client.getAllPackages();
      packages.then((onValue) {
        saveData(onValue);
        doStuff(onValue);
      });
    } else {
      print("Data already fetched");
      doStuff(onValue);
    }
  });*/
}

 doStuff(List<Package> packages) {
  Package package = packages.first;
  print(package.name);

  print(package.hashCode);
  print(package.latest);
  print(package.new_version_url);
  print(package.version_url);
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
  ScrollController _controller;
  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        print("reach the bottom");
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        print("reach the top");
      });
    }
  }


  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    List<Package> newItems = await getAllPackages();
    setState(() {
      packages = newItems;
    });
  }

  void _updateList() {
    setState(()  {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

    });
  }


  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
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
          return PackageTile(
              package: packages[index],
              onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) {
                          return Scaffold(
                              appBar: AppBar(
                                  title: Text(packages[index].name)
                              ),
                              body: PackageWidget(name: packages[index].name),
                          );
                      }
                  ));
              },
          );

        },
        physics: BouncingScrollPhysics(),
        controller: _controller
      ),
    );
  }
}

class PackageTile extends StatelessWidget {
  final Package package;
  final VoidCallback onTap;

  const PackageTile({Key key, this.package, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onTap,
        title: Text(package.name),
    );
  }
}

class PackageWidget extends StatefulWidget {
    final String name;

  const PackageWidget({Key key, this.name}) : super(key: key);

  @override
  PackageWidgetState createState() {
    return new PackageWidgetState();
  }
}

class PackageWidgetState extends State<PackageWidget> {


    Future<FullPackage> fullPackageFuture;

    @override
  void initState() {
    super.initState();

    fullPackageFuture = getFullPackage(widget.name);
  }
  @override
  Widget build(BuildContext context) {

    return FutureBuilder<FullPackage>(
        future: fullPackageFuture,
        builder: (context, snapshot) {
            if (!snapshot.hasData) {
                return CircularProgressIndicator();
            }
            List<Version> versions = snapshot.data.versions;
            return ListView.builder(
                itemCount: versions.length,
                itemBuilder: (context, index) {
                    return VersionWidget(
                        version: versions[index],
                        onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) {
                                    return Scaffold(
                                        appBar: AppBar(
                                            title: Text(snapshot.data.name + ", "+ versions[index].version ),
                                        ),
                                        body: PubspecWidget(
                                            pubspec: versions[index].pubspec,
                                        ),
                                    );
                                }
                            ));
                        },

                    );
                },
            );
        }
      );
  }
}

class VersionWidget extends StatelessWidget {
    final Version version;
    final VoidCallback onTap;

  const VersionWidget({Key key, this.version, this.onTap}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onTap,
        title: Text(version.version),
    );
  }
}


class PubspecWidget extends StatelessWidget {
    final Pubspec pubspec;

  const PubspecWidget({Key key, this.pubspec}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: <Widget>[
            ListTile(title: Text("author: " + pubspec.author)),
            ListTile(title: Text("description: " + pubspec.description)),
            ListTile(title: Text("environment: " + pubspec.environment.toString())),
            ListTile(title: Text("homepage: " + pubspec.homepage)),
            ListTile(title: Text("dependencies: " + pubspec.dependencies.toString())),

        ],
    );
  }
}


