import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Utiles{ //Esto es para almacenar el token que devuelve el inicio de sesión
  final _storage = const FlutterSecureStorage();
  void saveValue(key, value) async{
    await _storage.write(key: key, value: value);
  }

  Future<String?> getValue(key) async{
    return await _storage.read(key: key);
  }

  void removeItem(key) async{
    await _storage.delete(key: key);
  }

  void removeAllItem() async{
    await _storage.deleteAll();
  }

}