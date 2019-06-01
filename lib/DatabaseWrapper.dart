import 'dart:convert';
import 'dart:async';
import 'package:pub_client/pub_client.dart';

import 'Database.dart';
import 'PackageClass.dart';


class AppSerialization {

  final Database database;

  AppSerialization(this.database);

  Future<PackageClass> readData() async {
    final prefs = database;
    final key = 'database';
    final value = prefs.getPackageClasses() ?? null;
    print('read: $value');
    return value;
  }

 saveData(PackageClass packages) async {
    final prefs = database;
    final key = 'database';
    database.insertPackage(packages);
  }

  static List<String> serialize(List<PackageClass> packages) {
    return packages
        .map((package) => package.toJson())
        .map(json.encode)
        .toList();
  }

 static List<PackageClass> deserialize(List<String> packageListString) {
    return packageListString.map((it) => packageClassFromJson(it)).toList();
  }
}