import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_practica3/controls/servicio_back/FacadeService.dart';
import 'package:frontend_practica3/controls/servicio_back/RespuestaGenerica.dart';
import 'package:frontend_practica3/controls/utiles/Utiles.dart';
import 'package:frontend_practica3/views/noticiaDetalleView.dart';
import 'package:validators/validators.dart';

//fstful
class NoticiasView extends StatefulWidget {
  const NoticiasView({Key? key}) : super(key: key);

  @override
  _NoticiasViewState createState() => _NoticiasViewState();
}

class _NoticiasViewState extends State<NoticiasView> {
  List<dynamic> noticias = [];
  bool cargando = true;
  final String URL_Media = "http://localhost:3001/multimedia/";
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    FacadeService servicio = FacadeService();
    try {
      RespuestaGenerica respuesta = await servicio.listarNoticiasTodo();
      setState(() {
        cargando = false;
        if (respuesta.code == 200) {
          noticias = respuesta.datos;
          //log(noticias.toString());
        }
      });
    } catch (error) {
      setState(() {
        cargando = false;
      });
      log(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text("Noticias",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 30)),
            ),
            for (var noticia in noticias)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NoticiaDetalleView(noticia: noticia),
                    ),
                  );
                },
                child: Card(
                  child: ListTile(
                    leading: Image.network(
                      URL_Media + noticia['archivo'],
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(noticia['titulo'],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Fecha: ${noticia['fecha']}"),
                        Text(
                            "Autor: ${noticia['persona']['nombres']} ${noticia['persona']['apellidos']}"),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
