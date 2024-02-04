import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_practica3/controls/servicio_back/FacadeService.dart';
import 'package:frontend_practica3/controls/servicio_back/RespuestaGenerica.dart';
import 'package:frontend_practica3/controls/utiles/Utiles.dart';
import 'package:frontend_practica3/views/noticiaDetalleView.dart';
import 'package:validators/validators.dart';

class ComentarView extends StatefulWidget {
  final String external_noticia;
  const ComentarView({ Key? key, required this.external_noticia }) : super(key: key);
  

  @override
  _ComentarViewState createState() => _ComentarViewState();
}

class _ComentarViewState extends State<ComentarView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.external_noticia),
      ),
    );
  }
}