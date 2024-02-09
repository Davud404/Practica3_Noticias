import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_practica3/controls/Conexion.dart';
import 'package:frontend_practica3/controls/servicio_back/FacadeService.dart';
import 'package:frontend_practica3/controls/servicio_back/RespuestaGenerica.dart';
import 'package:frontend_practica3/controls/utiles/Utiles.dart';
import 'package:frontend_practica3/views/mapaComentarios.dart';
import 'package:frontend_practica3/views/mapaTodosComentarios.dart';
import 'package:frontend_practica3/views/noticiaDetalleView.dart';
import 'package:frontend_practica3/views/perfilView.dart';
import 'package:validators/validators.dart';

//fstful
class NoticiasView extends StatefulWidget {
  const NoticiasView({Key? key}) : super(key: key);

  @override
  _NoticiasViewState createState() => _NoticiasViewState();
}

Future<String?> _obtenerRolUser() async {
  Utiles util = Utiles();
  return await util.getValue('rol');
}

class _NoticiasViewState extends State<NoticiasView> {
  Conexion conexion = Conexion();
  List<dynamic> noticias = [];
  List<dynamic> comentarios = [];
  bool cargando = true;
  late String URL_Media;
  late String rol = '';
  late String usuario = '';
  late String external = '';

  @override
  void initState() {
    super.initState();
    URL_Media = conexion.URL_Media;
    _cargarRol();
    _obtenerUser();
    fetchData();
  }

  // Nueva función para cargar el rol del usuario
  void _cargarRol() async {
    final rolUser = await _obtenerRolUser();
    setState(() {
      rol = rolUser ?? 'usuario'; // Actualiza el valor de rol
    });
  }

  void _obtenerUser() async {
    Utiles util = Utiles();
    final user = await util.getValue('user');
    final exter = await util.getValue('external');
    setState(() {
      usuario = user ?? '';
      external = exter ?? '';
    });
  }

  Future<void> fetchData() async {
    FacadeService servicio = FacadeService();
    try {
      RespuestaGenerica respuesta = await servicio.listarNoticiasTodo();
      RespuestaGenerica comentariosAux = await servicio.obtenerTodosComentarios();
      setState(() {
        cargando = false;
        if (respuesta.code == 200 || comentariosAux.code == 200) {
          noticias = respuesta.datos;
          comentarios = comentariosAux.datos;
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

  void _cerrarSesion() async {
    Utiles util = Utiles();
    util.removeAllItems();
    setState(() {
      rol = ''; // Restablece el valor del rol a vacío
    });
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    if (noticias.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Cargando...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Container(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Noticias'),
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('$usuario'),
                ),
                ListTile(
                  title: Text('Ver perfil'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PerfilView(external_user: external),
                      ),
                    );
                  },
                ),
                if (rol ==
                    'administrador')
                  ListTile(
                    title: Text('Ver Mapa'),
                    onTap: () {
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapaTodosComentarios(
                                  comentarios: comentarios),
                            ),
                          );
                    },
                  ),
                ListTile(
                  title: Text('Cerrar Sesión'),
                  onTap: () {
                    _cerrarSesion();
                  },
                ),
              ],
            ),
          ),
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                              height: 10), // Espacio entre el texto y el botón
                          rol == 'administrador'
                              ? ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MapaComentarios(noticia: noticia),
                                      ),
                                    );
                                  },
                                  child: Text('Ver Mapa'),
                                )
                              : SizedBox
                                  .shrink(), // Para ocultar el botón si no es administrador
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
}
