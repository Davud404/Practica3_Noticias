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

class EditarComentario extends StatefulWidget {
  final dynamic comentario;
  const EditarComentario({ Key? key, required this.comentario }) : super(key: key);

  @override
  _EditarComentarioState createState() => _EditarComentarioState();
}

String obtenerFechaActual() {
  DateTime now = DateTime.now();
  String fecha = DateFormat('yyyy-MM-dd').format(now);
  return fecha;
}

class _EditarComentarioState extends State<EditarComentario> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController comentarioControl = TextEditingController();


  @override
  void initState() {
    super.initState();
    comentarioControl.text = widget.comentario['cuerpo'];
  }

  void _editarComentario() async{
    setState(() {
      FacadeService servicio = FacadeService();
      final String fecha = obtenerFechaActual();
      if(_formKey.currentState!.validate()){
      Map<String,String> mapa = {
        "cuerpo": comentarioControl.text,
        "fecha": fecha,
      };
      log(mapa.toString());
      servicio.modificarComentario(widget.comentario['external_id'], mapa).then((value) {
        if(value.code == 200){
          log('comentario modificado');
        }else{
          log('error');
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
                      _editarComentario();
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
                      'Editar comentario',
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