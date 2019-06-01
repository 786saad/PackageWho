import 'package:package_who/Database.dart';
import 'package:package_who/DatabaseWrapper.dart';
import 'package:package_who/PackageClass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'package:test_api/test_api.dart';

void main() async{



  group("adsf", () {});
  test('foo', () async {
    var appSerialization = AppSerialization(Database());

    var saveData = appSerialization.saveData(Database.getMockData());
    final variable = await appSerialization.readData();
    print(variable);
    //print(variable.first.toString());
  });

}



class _MockSharedPreferences extends Mock implements SharedPreferences {}