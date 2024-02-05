import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_practica3/controls/servicio_back/FacadeService.dart';
import 'package:frontend_practica3/controls/servicio_back/RespuestaGenerica.dart';
import 'package:frontend_practica3/controls/utiles/Utiles.dart';
import 'package:frontend_practica3/views/noticiaDetalleView.dart';
import 'package:validators/validators.dart';
import 'package:geolocator/geolocator.dart';

class ComentarView extends StatefulWidget {
  final String external_noticia;
  const ComentarView({Key? key, required this.external_noticia})
      : super(key: key);

  @override
  _ComentarViewState createState() => _ComentarViewState();
}

Future<Position> _obtenerPosicion() async {
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.medium,
  );
}

class _ComentarViewState extends State<ComentarView> {
  late Future<Position> posicion;
  String? latitud;
  String? longitud;

  Utiles util = Utiles();
  Future<String?> external = Utiles().getValue('external');
  final _formKey = GlobalKey<FormState>();
  final TextEditingController comentarioControl = TextEditingController();

  @override
  void initState(){
    super.initState();
    posicion = _obtenerPosicion();
    posicion.then((coordenadas){
      setState(() {
        latitud = coordenadas.latitude.toString();
        longitud = coordenadas.longitude.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
        title: Text("Comentario"),
      ),
      
      body: ListView(
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: Text(latitud ?? 'no latitud',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 30)),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: Text(longitud ?? 'no longitud',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 30)),
            ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: comentarioControl,
              validator:(value){
                if(value!.isEmpty){
                  return "Escriba un comentario";
                }
              }
            ),
          ),
          Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          //Navigator.push(
                          //);
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
