// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:package_who/main.dart';
import 'package:pub_client/pub_client.dart';

void main() async{
  var client = new PubClient();
  List<Package> packages = await client.getAllPackages();

  Package package = packages.first;
  print(package.name);

  print(package.hashCode);
  print(package.latest);
  print(package.new_version_url);
  print(package.version_url);
  print(".....");
  print(package.toJson());
}
