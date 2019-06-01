// Open the database and store the reference
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pub_client/pub_client.dart';
import 'package:sqflite/sqflite.dart';

import 'PackageClass.dart';



class Database {



  initDB() async {
    var database = await openDatabase(await getDatabasePath());
    database.execute("CREATE TABLE Package_Basic ("
        "id TEXT PRIMARY KEY,"
        "uploaders TEXT,"
        "versions TEXT"
        ")");
  }

  Future<String> getDatabasePath() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, "Packages.db");
  }

  // Next, define a function that inserts dogs into the database
  Future<void> insertPackage(PackageClass package) async {
    // Get a reference to the database
    final database = await openDatabase(await getDatabasePath());

    // Insert the Dog into the correct table. You may also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await database.insert(
      'Package_Basic',
      package.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<String>> getStringList() async {
    final database = await openDatabase(await getDatabasePath());
    final List<Map<String, dynamic>> maps = await database.query('Package_Basic');
    return maps.map((map) => map.values).map((it) => it.toString());
  }

  Future<PackageClass> getPackageClasses() async {
    final list = await getStringList();
    return packageClassFromJson(list.first);
  }

  void setStringList(String key, List<String> serialize) {}

  static PackageClass getMockData() {
    String all = '{"name":"place_picker","latest":{"archive_url":"https://pub.dartlang.org/packages/place_picker/versions/0.9.1.tar.gz","pubspec":{"version":"0.9.1","name":"place_picker","dependencies":{"google_maps_flutter":"^0.5.15","http":"^0.12.0+1","location":"^2.3.5","flutter":{"sdk":"flutter"}},"flutter":null,"author":"De-Great Yartey <mail@degreat.co.uk>","description":"Place picker fully written in dart for Flutter. Comes with autocomplete suggestions and nearby locations list.","environment":{"sdk":">=2.1.0 <3.0.0"},"homepage":"https://github.com/blackmann/locationpicker","dev_dependencies":{"flutter_test":{"sdk":"flutter"}}},"version":"0.9.1"},"versions":[{"archive_url":"https://pub.dartlang.org/packages/place_picker/versions/0.0.1.tar.gz","pubspec":{"version":"0.0.1","name":"place_picker","dependencies":{"google_maps_flutter":"^0.5.15","http":"^0.12.0+1","location":"^2.3.5","flutter":{"sdk":"flutter"}},"flutter":null,"author":"De-Great Yartey <mail@degreat.co.uk>","description":"A new Flutter package project.","environment":{"sdk":">=2.1.0 <3.0.0"},"homepage":"https://degreat.co.uk","dev_dependencies":{"flutter_test":{"sdk":"flutter"}}},"version":"0.0.1"},{"archive_url":"https://pub.dartlang.org/packages/place_picker/versions/0.0.2.tar.gz","pubspec":{"version":"0.0.2","name":"place_picker","dependencies":{"google_maps_flutter":"^0.5.15","http":"^0.12.0+1","location":"^2.3.5","flutter":{"sdk":"flutter"}},"flutter":null,"author":"De-Great Yartey <mail@degreat.co.uk>","description":"Place picker fully written in dart for Flutter. Comes with autocomplete suggestions and nearby locations list.","environment":{"sdk":">=2.1.0 <3.0.0"},"homepage":"https://degreat.co.uk","dev_dependencies":{"flutter_test":{"sdk":"flutter"}}},"version":"0.0.2"},{"archive_url":"https://pub.dartlang.org/packages/place_picker/versions/0.9.0.tar.gz","pubspec":{"version":"0.9.0","name":"place_picker","dependencies":{"google_maps_flutter":"^0.5.15","http":"^0.12.0+1","location":"^2.3.5","flutter":{"sdk":"flutter"}},"flutter":null,"author":"De-Great Yartey <mail@degreat.co.uk>","description":"Place picker fully written in dart for Flutter. Comes with autocomplete suggestions and nearby locations list.","environment":{"sdk":">=2.1.0 <3.0.0"},"homepage":"https://github.com/blackmann/locationpicker","dev_dependencies":{"flutter_test":{"sdk":"flutter"}}},"version":"0.9.0"},{"archive_url":"https://pub.dartlang.org/packages/place_picker/versions/0.9.1.tar.gz","pubspec":{"version":"0.9.1","name":"place_picker","dependencies":{"google_maps_flutter":"^0.5.15","http":"^0.12.0+1","location":"^2.3.5","flutter":{"sdk":"flutter"}},"flutter":null,"author":"De-Great Yartey <mail@degreat.co.uk>","description":"Place picker fully written in dart for Flutter. Comes with autocomplete suggestions and nearby locations list.","environment":{"sdk":">=2.1.0 <3.0.0"},"homepage":"https://github.com/blackmann/locationpicker","dev_dependencies":{"flutter_test":{"sdk":"flutter"}}},"version":"0.9.1"}]}';
    var decode = packageClassFromJson(all);
    return decode;
  }

}

