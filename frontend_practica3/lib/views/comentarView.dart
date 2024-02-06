import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_practica3/controls/servicio_back/FacadeService.dart';
import 'package:frontend_practica3/controls/servicio_back/RespuestaGenerica.dart';
import 'package:frontend_practica3/controls/utiles/Utiles.dart';
import 'package:frontend_practica3/views/noticiaDetalleView.dart';
import 'package:validators/validators.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class ComentarView extends StatefulWidget {
  final dynamic noticia;
  const ComentarView({Key? key, required this.noticia}) : super(key: key);

  @override
  _ComentarViewState createState() => _ComentarViewState();
}

Future<Position> _obtenerPosicion() async {
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.medium,
  );
}

Future<String?> _obtenerExternalUser() async {
  Utiles util = Utiles();
  return await util.getValue('external');
}

String obtenerFechaActual() {
  DateTime now = DateTime.now();
  String fecha = DateFormat('yyyy-MM-dd').format(now);
  return fecha;
}

class _ComentarViewState extends State<ComentarView> {
  late Future<Position> posicion;
  double? latitud;
  double? longitud;
  Future<String?> external = _obtenerExternalUser();

  Utiles util = Utiles();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController comentarioControl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _guardarComentario() async {
    final externalValue = await external;
    final posicion =
        await _obtenerPosicion(); // Espera a que se resuelva la Future

    setState(() {
      latitud = posicion.latitude;
      longitud = posicion.longitude;
    });

    //log(latitud.toString());
    //log(longitud.toString());

    setState(() {
      FacadeService servicio = FacadeService();
      final String hora = obtenerFechaActual();
      if (_formKey.currentState!.validate()) {
        Map<String, dynamic> mapa = {
          "cuerpo": comentarioControl.text,
          "fecha": hora,
          "longitud": longitud, // Si es null, se establece en 0.0
          "latitud": latitud, // Si es null, se establece en 0.0
          "usuario": externalValue,
        };
        //log(mapa.toString());
        servicio.guardarComentario(widget.noticia['id'], mapa).then((value) async {
        if (value.code == 200) {
          log('guardado');
        } else {
          log('no se guardó');
        }
      });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Comentario"),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                  controller: comentarioControl,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Escriba un comentario";
                    }
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                    onPressed: () {
                      _guardarComentario();
                      Navigator.pushNamed(context, '/noticias');
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NoticiaDetalleView(noticia: widget.noticia),
                        ),
                      );*/
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
    );
  }
}
