import 'dart:async';
import 'dart:convert';

import 'package:pub_client/pub_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  print("Starting");
  print("Starting pubclient");
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
  });
}

Future<List<Package>> readData() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'database';
  final value = prefs.getString(key) ?? null;
  print('read: $value');
  return json.decode(value);
}

saveData(List<Package> packages) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'database';
  prefs.setString(key, serialize(packages));
}

String serialize(List<Package> packages) {
  return json.encode(packages.map((it) => it.toJson()).toList());
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

abstract class StorageAbstraction {
  Future<void> set(String key, String value);

  Future<String> get(String key);
}