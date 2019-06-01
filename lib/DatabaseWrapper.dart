import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:pub_client/pub_client.dart';

Future<List<Package>> readData() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'database';
  final value = prefs.getStringList(key) ?? null;
  print('read: $value');
  return deserialize(value);
}

 saveData(List<Package> packages) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'database';
  prefs.setStringList(key, serialize(packages));
}

List<String> serialize(List<Package> packages) {
  List<String> packageList = new List();
  packages.forEach((package) 
  {packageList.add(json.encode(package.toJson()));});
  return packageList;
}

List<Package> deserialize(List<String> packageListString) {
  List<Package> packageList = new List();
  packageListString.forEach((packageString) {packageList.add(json.decode(packageString));});
  return packageList;
}