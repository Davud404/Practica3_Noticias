import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend_practica3/controls/Conexion.dart';
import 'package:frontend_practica3/controls/servicio_back/FacadeService.dart';
import 'package:frontend_practica3/controls/servicio_back/RespuestaGenerica.dart';
import 'package:frontend_practica3/views/comentarView.dart';

class NoticiaDetalleView extends StatefulWidget {
  final dynamic noticia;
  const NoticiaDetalleView({Key? key, required this.noticia}) : super(key: key);

  @override
  _NoticiaDetalleViewState createState() => _NoticiaDetalleViewState();
}

class _NoticiaDetalleViewState extends State<NoticiaDetalleView> {
  //final String URL_Media = "http://localhost:3001/multimedia/";
  Conexion conexion = Conexion();
  List<dynamic> comentarios = [];
  late String URL_Media;
  //final String URL_Media = "http://192.168.1.14:3001/multimedia";

  @override
  void initState() {
    super.initState();
    URL_Media = conexion.URL_Media;
    fetchData();
  }

  Future<void> fetchData() async {
    FacadeService servicio = FacadeService();
    try {
      RespuestaGenerica respuesta =
          await servicio.listarComentarios(widget.noticia['id']);
          //slog(widget.noticia['id']);
      setState(() {
        if (respuesta.code == 200) {
          comentarios = respuesta.datos;
        }
      });
    } catch (error) {
      log(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Noticia"),
        ),
        body: ListView(children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.noticia['titulo'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 10),
                Image.network(
                  URL_Media + widget.noticia['archivo'],
                  width: 300,
                  fit: BoxFit.cover,
                ),
                Text(
                  "Fecha: ${widget.noticia['fecha']}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  "Autor: ${widget.noticia['persona']['nombres']} ${widget.noticia['persona']['apellidos']}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  widget.noticia['cuerpo'],
                  style: TextStyle(fontSize: 16),
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ComentarView(
                                  noticia: widget.noticia),
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
                          'Comentar',
                          style: TextStyle(fontSize: 20),
                        ))
                  ],
                ),
              ],
            ),
          ),
          for (var comentario in comentarios)
            Card(
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${comentario['persona']['nombres']} ${comentario['persona']['apellidos']}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(comentario['cuerpo'],
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
        ]));
  }
}
