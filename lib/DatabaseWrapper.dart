import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:pub_client/pub_client.dart';

Future<List<Package>> readData() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'database';
  final value = prefs.getString(key) ?? null;
  print('read: $value');
}

 saveData(List<Package> packages) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'database';
  prefs.setString(key, serialize(packages));
}

String serialize(List<Package> packages) {
  return json.encode(packages.map((it) => it.toJson()).toList());
}