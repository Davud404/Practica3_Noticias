import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_practica3/controls/Conexion.dart';
import 'package:frontend_practica3/controls/servicio_back/FacadeService.dart';
import 'package:frontend_practica3/controls/servicio_back/RespuestaGenerica.dart';
import 'package:frontend_practica3/controls/utiles/Utiles.dart';
import 'package:frontend_practica3/views/mapaComentarios.dart';
import 'package:frontend_practica3/views/noticiaDetalleView.dart';
import 'package:validators/validators.dart';

class EditarPerfil extends StatefulWidget {
  final dynamic persona;
  const EditarPerfil({ Key? key , required this.persona}) : super(key: key);

  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar Perfil'),
        ),
        /*body: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${persona['nombres']} ${persona['apellidos']}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
                  
                ],
              ),
            ),
            Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          /*Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ComentarView(
                                  noticia: widget.noticia),
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
        ),*/
      );
  }
}