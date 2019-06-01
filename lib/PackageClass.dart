// To parse this JSON data, do
//
//     final packageClass = packageClassFromJson(jsonString);

import 'dart:convert';

PackageClass packageClassFromJson(String str) => PackageClass.fromJson(json.decode(str));

String packageClassToJson(PackageClass data) => json.encode(data.toJson());

class PackageClass {
  String name;
  Latest latest;
  List<Latest> versions;

  PackageClass({
    this.name,
    this.latest,
    this.versions,
  });

  factory PackageClass.fromJson(Map<String, dynamic> json) => new PackageClass(
    name: json["name"],
    latest: Latest.fromJson(json["latest"]),
    versions: new List<Latest>.from(json["versions"].map((x) => Latest.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "latest": latest.toJson(),
    "versions": new List<dynamic>.from(versions.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'PackageClass{name: $name, latest: $latest, versions: $versions}';
  }


}

class Latest {
  String archiveUrl;
  Pubspec pubspec;
  String version;

  Latest({
    this.archiveUrl,
    this.pubspec,
    this.version,
  });

  factory Latest.fromJson(Map<String, dynamic> json) => new Latest(
    archiveUrl: json["archive_url"],
    pubspec: Pubspec.fromJson(json["pubspec"]),
    version: json["version"],
  );

  Map<String, dynamic> toJson() => {
    "archive_url": archiveUrl,
    "pubspec": pubspec.toJson(),
    "version": version,
  };
}

class Pubspec {
  String version;
  String name;
  Dependencies dependencies;
  dynamic flutter;
  String author;
  String description;
  Environment environment;
  String homepage;
  DevDependencies devDependencies;

  Pubspec({
    this.version,
    this.name,
    this.dependencies,
    this.flutter,
    this.author,
    this.description,
    this.environment,
    this.homepage,
    this.devDependencies,
  });

  factory Pubspec.fromJson(Map<String, dynamic> json) => new Pubspec(
    version: json["version"],
    name: json["name"],
    dependencies: Dependencies.fromJson(json["dependencies"]),
    flutter: json["flutter"],
    author: json["author"],
    description: json["description"],
    environment: Environment.fromJson(json["environment"]),
    homepage: json["homepage"],
    devDependencies: DevDependencies.fromJson(json["dev_dependencies"]),
  );

  Map<String, dynamic> toJson() => {
    "version": version,
    "name": name,
    "dependencies": dependencies.toJson(),
    "flutter": flutter,
    "author": author,
    "description": description,
    "environment": environment.toJson(),
    "homepage": homepage,
    "dev_dependencies": devDependencies.toJson(),
  };
}

class Dependencies {
  String googleMapsFlutter;
  String http;
  String location;
  Environment flutter;

  Dependencies({
    this.googleMapsFlutter,
    this.http,
    this.location,
    this.flutter,
  });

  factory Dependencies.fromJson(Map<String, dynamic> json) => new Dependencies(
    googleMapsFlutter: json["google_maps_flutter"],
    http: json["http"],
    location: json["location"],
    flutter: Environment.fromJson(json["flutter"]),
  );

  Map<String, dynamic> toJson() => {
    "google_maps_flutter": googleMapsFlutter,
    "http": http,
    "location": location,
    "flutter": flutter.toJson(),
  };
}

class Environment {
  Sdk sdk;

  Environment({
    this.sdk,
  });

  factory Environment.fromJson(Map<String, dynamic> json) => new Environment(
    sdk: sdkValues.map[json["sdk"]],
  );

  Map<String, dynamic> toJson() => {
    "sdk": sdkValues.reverse[sdk],
  };
}

enum Sdk { FLUTTER, THE_210300 }

final sdkValues = new EnumValues({
  "flutter": Sdk.FLUTTER,
  ">=2.1.0 <3.0.0": Sdk.THE_210300
});

class DevDependencies {
  Environment flutterTest;

  DevDependencies({
    this.flutterTest,
  });

  factory DevDependencies.fromJson(Map<String, dynamic> json) => new DevDependencies(
    flutterTest: Environment.fromJson(json["flutter_test"]),
  );

  Map<String, dynamic> toJson() => {
    "flutter_test": flutterTest.toJson(),
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }


}