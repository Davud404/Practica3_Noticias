import 'dart:convert';
import 'dart:developer';

import 'package:frontend_practica3/controls/Conexion.dart';
import 'package:frontend_practica3/controls/servicio_back/RespuestaGenerica.dart';
import 'package:frontend_practica3/controls/servicio_back/modelo/InicioSesion.dart';
import 'package:http/http.dart' as http;

class FacadeService{
  Conexion c = Conexion();
  Future<InicioSesion> inicioSesion(Map<String, String> mapa) async{
    Map<String, String> _header = {'Content-Type': 'application/json'};
    final String _url = c.URL + '/login';
    final uri = Uri.parse(_url);
    InicioSesion isw = InicioSesion();
    
    try {
      final response = await http.post(uri, headers: _header, body:jsonEncode(mapa));
      //log(response.statusCode.toString());
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          isw.code = 404;
          isw.msg = "Error";
          isw.tag = "Recurso no encontrado";
          isw.datos = {};
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          isw.code = mapa['code'];
          isw.msg = mapa['msg'];
          isw.tag = mapa['tag'];
          isw.datos = mapa['datos'];
          //return _response(mapa['code'], mapa['msg'], mapa['datos']);
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        isw.code = mapa['code'];
        isw.msg = mapa['msg'];
        isw.tag = mapa['tag'];
        isw.datos = mapa['datos'];
        //return _response(mapa['code'], mapa['msg'], mapa['datos']);
        //log(response.body);
      }
      //return RespuestaGenerica();
    } catch (e) {
      //return _response(500, "Error inesperado", []);
      isw.code = 500;
      isw.msg = "Error";
      isw.tag = "Error inesperado";
      isw.datos = {};
    }
    return isw;
  }

  Future<RespuestaGenerica> listarNoticiasTodo() async{
    return await c.solicitud_get('/noticias', false);
  }

  Future<RespuestaGenerica> registrarUsuario(Map<String, String> data) async{
    return await c.solicitud_post('/usuarios/guardar', false, data);
  }

  Future<RespuestaGenerica> listarComentarios(external) async{
    return await c.solicitud_get('/noticias/comentarios/$external', false);
  }



}