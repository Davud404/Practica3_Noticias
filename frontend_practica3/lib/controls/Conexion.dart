import 'package:frontend_practica3/controls/servicio_back/RespuestaGenerica.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend_practica3/controls/utiles/Utiles.dart';

class Conexion {
  //final String URL = "http://localhost:3001/api"; //Para celular cambiar localhost por 10.20.139.11
  //final String URL_Media = "http://localhost:3001/multimedia";
  final String URL = "http://192.168.1.14:3001/api";
  final String URL_Media = "http://192.168.1.14:3001/multimedia/";
  static bool NO_TOKEN = false;
  //token
  Future<RespuestaGenerica> solicitud_get(String recurso, bool token) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    if (token) {
      Utiles util = new Utiles();
      String? tokenA = await util.getValue('token'); 
      //La incógnita significa que si hay dato, devuelve el String, sino, devuelve null
      log(tokenA.toString());
      _header = {'Content-Type': 'application/json', 'token': tokenA.toString()};
    }
    final String _url = URL + recurso;
    final uri = Uri.parse(_url);
    try {
      final response = await http.get(uri, headers: _header);
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          return _response(404, "Recurso no encontrado", []);
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          return _response(mapa['code'], mapa['msg'], mapa['datos']);
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        return _response(mapa['code'], mapa['msg'], mapa['datos']);
        //log(response.body);
      }
      //return RespuestaGenerica();
    } catch (e) {
      return _response(500, "Error inesperado", []);
    }
  }

  Future<RespuestaGenerica> solicitud_post(String recurso, bool token, Map<dynamic,dynamic> mapa) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    if (token) {
      Utiles util = new Utiles();
      String? tokenA = await util.getValue('token'); 
      _header = {'Content-Type': 'application/json', 'token': tokenA.toString()};
    }
    final String _url = URL + recurso;
    final uri = Uri.parse(_url);
    try {
      final response = await http.post(uri, headers: _header, body:jsonEncode(mapa));
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          return _response(404, "Recurso no encontrado", []);
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          return _response(mapa['code'], mapa['msg'], mapa['datos']);
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        return _response(mapa['code'], mapa['msg'], mapa['datos']);
        //log(response.body);
      }
      //return RespuestaGenerica();
    } catch (e) {
      return _response(500, "Error inesperado", []);
    }
  }

  RespuestaGenerica _response(int code, String msg, dynamic data) {
    var respuesta = RespuestaGenerica();
    respuesta.code = code;
    respuesta.datos = data;
    respuesta.msg = msg;
    return respuesta;
  }
}
