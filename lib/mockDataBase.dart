import 'package:pub_client/pub_client.dart';
import 'dart:async';

Future<FullPackage> getFullPackage(String name) async {
    return new PubClient().getPackage(name);
}