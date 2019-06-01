import 'dart:convert';

import 'package:pub_client/pub_client.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

Future<FullPackage> getFullPackage(String name) async {
    return new PubClient().getPackage(name);
}

Future<List<Package>> getAllPackages() async {
    return new PubClient().getAllPackages();
}

class MyPubPackages {
    
    static const String KEY = "P";
    
    Future<bool> hasCache() async {
        var instance = await SharedPreferences.getInstance();
        return instance.getKeys().contains(KEY);
    }
    
    Future<List<Package>> getCache() async{
        var instance = await SharedPreferences.getInstance();
        var encoded = instance.getString(KEY);
        dynamic it = json.decode(encoded);
        
        List<Package> packages = [];
        for(dynamic item in it) {
            Map<String, dynamic> map = item;
            var p = Package.fromJson(map);
            packages.add(p);
        }
        return packages;
    }
    
    Future setCache(List<Package> packages) async {
        var map = packages.map((it) => it.toJson()).toList();
        String encoded = json.encode(map);
        var instance = await SharedPreferences.getInstance();
        instance.setString(KEY, encoded);
    }
    
    Future<List<Package>> getRemotePackages() {
        return new PubClient().getAllPackages();
    }
    
    Future<List<Package>> getAllPackages() async {
        if(await hasCache()) {
            return getCache();
        } else {
            List<Package> packages = await getRemotePackages();
            setCache(packages);
            return packages;
        }
    }
    
}