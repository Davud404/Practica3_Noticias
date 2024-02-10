import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_practica3/controls/Conexion.dart';
import 'package:frontend_practica3/controls/servicio_back/FacadeService.dart';
import 'package:frontend_practica3/controls/servicio_back/RespuestaGenerica.dart';
import 'package:frontend_practica3/controls/utiles/Utiles.dart';
import 'package:frontend_practica3/views/editarComentario.dart';
import 'package:frontend_practica3/views/editarPerfil.dart';
import 'package:frontend_practica3/views/mapaComentarios.dart';
import 'package:frontend_practica3/views/noticiaDetalleView.dart';
import 'package:validators/validators.dart';

class PerfilUserView extends StatefulWidget {
  final dynamic usuario;
  const PerfilUserView({ Key? key, required this.usuario }) : super(key: key);

  @override
  _PerfilUserViewState createState() => _PerfilUserViewState();
}

class _PerfilUserViewState extends State<PerfilUserView> {
  List<dynamic> comentarios = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async{
    FacadeService servicio = FacadeService();
    try {
      RespuestaGenerica respuesta = await servicio.obtenerComentariosUser(widget.usuario['external_id']);
      setState(() {
        comentarios = respuesta.datos;
      });
    } catch (error) {
      log(error.toString());
    }
  }

  void _suspenderCuenta(){
    setState(() {
      FacadeService servicio = FacadeService();
      Map<String, bool> mapa = {
        "estado_cuenta": false,
      };
      servicio.suspenderCuenta(widget.usuario['external_id'], mapa).then((value) async{
        if(value.code == 200){
          log('cuenta suspendida');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(comentarios == []){
      return Scaffold(
        appBar: AppBar(
          title: Text('Cargando...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }else{
      return Scaffold(
        appBar: AppBar(
          title: Text('Perfil'),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Información General",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Usuario: ${widget.usuario['nombres']} ${widget.usuario['apellidos']}",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Celular: ${widget.usuario['celular']}",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Correo: ${widget.usuario['cuenta']['correo']}",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                          onPressed: () {
                            _suspenderCuenta();
                            Navigator.pushNamed(context, '/noticias');
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          child: const Text(
                            'Suspender Cuenta',
                            style: TextStyle(fontSize: 16),
                          ))
                    ],
                  ),
                  Text(
                    "Comentarios",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  for (var comentario in comentarios)
                    Card(
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Noticia: ${comentario['noticia']['titulo']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(comentario['cuerpo'],
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}