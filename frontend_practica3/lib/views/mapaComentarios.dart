import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_practica3/controls/Conexion.dart';
import 'package:frontend_practica3/controls/servicio_back/FacadeService.dart';
import 'package:frontend_practica3/controls/servicio_back/RespuestaGenerica.dart';
import 'package:frontend_practica3/controls/utiles/Utiles.dart';
import 'package:frontend_practica3/views/noticiaDetalleView.dart';
import 'package:validators/validators.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class MapaComentarios extends StatefulWidget {
  final dynamic noticia;
  const MapaComentarios({Key? key, required this.noticia}) : super(key: key);

  @override
  _MapaComentariosState createState() => _MapaComentariosState();
}

class _MapaComentariosState extends State<MapaComentarios> {
  Conexion conexion = Conexion();
  List<dynamic> comentarios = [];
  List<dynamic> coordenadas = [];
  late Future<Position> posicion;
  double? latitud;
  double? longitud;

  @override
  void initState() {
    super.initState();
    posicion = _obtenerPosicion(); // Inicia la obtención de la posición
    posicion.then((coordenadas) {
      setState(() {
        latitud = coordenadas.latitude;
        longitud = coordenadas.longitude;
      });
    });
    fetchData();
  }

  Future<void> fetchData() async {
    FacadeService servicio = FacadeService();
    try {
      RespuestaGenerica respuesta =
          await servicio.listarComentarios(widget.noticia['id']);
      setState(() {
        if (respuesta.code == 200) {
          comentarios = respuesta.datos;
        }
      });
    } catch (error) {
      log(error.toString());
    }
  }

  Future<Position> _obtenerPosicion() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: posicion,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras se obtiene la posición
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Maneja cualquier error que pueda ocurrir al obtener la posición
          return Text('Error al obtener la posición: ${snapshot.error}');
        } else {
          // Construye el mapa utilizando la posición obtenida
          return FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(latitud ?? 51.509364, longitud ?? -0.128928),
              initialZoom: 16,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
            ],
          );
        }
      },
    );
  }
}
