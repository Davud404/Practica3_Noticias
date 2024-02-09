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

class PerfilView extends StatefulWidget {
  final String external_user;
  const PerfilView({Key? key, required this.external_user}) : super(key: key);
  @override
  _PerfilViewState createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  dynamic persona;
  List<dynamic> comentarios = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    FacadeService servicio = FacadeService();
    try {
      RespuestaGenerica respuesta =
          await servicio.obtenerUsuario(widget.external_user);
      RespuestaGenerica comentariosAux =
          await servicio.obtenerComentariosUser(widget.external_user);
      setState(() {
        if (respuesta.code == 200) {
          persona = respuesta.datos;
          comentarios = comentariosAux.datos;
          //log(comentarios.toString());
          //log(persona.toString());
        }
      });
    } catch (error) {
      log('error pipipipipi');
      log(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (persona == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Cargando...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Usuario: ${persona['nombres']} ${persona['apellidos']}",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Celular: ${persona['celular']}",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Correo: ${persona['cuenta']['correo']}",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditarPerfil(persona: persona),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          child: const Text(
                            'Editar Información',
                            style: TextStyle(fontSize: 20),
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
                            Container(
                              height: 50,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10,
                                  0), //Función para padding de todos lados Left, Top, Right, Bottom
                              child: ElevatedButton(
                                child: const Text("Editar"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditarComentario(comentario: comentario),
                                    ),
                                  );
                                },
                              ),
                            ),
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
