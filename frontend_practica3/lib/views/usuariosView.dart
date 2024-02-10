import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend_practica3/controls/servicio_back/FacadeService.dart';
import 'package:frontend_practica3/controls/servicio_back/RespuestaGenerica.dart';
import 'package:frontend_practica3/views/perfilUserView.dart';

class UsuariosView extends StatefulWidget {
  const UsuariosView({Key? key}) : super(key: key);

  @override
  _UsuariosViewState createState() => _UsuariosViewState();
}

class _UsuariosViewState extends State<UsuariosView> {
  List<dynamic> usuarios = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    log('entro a usuarios');
    FacadeService servicio = FacadeService();
    try {
      RespuestaGenerica respuesta = await servicio.obtenerUsuarios();
      setState(() {
        if (respuesta.code == 200) {
          usuarios = respuesta.datos;
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
        title: Text('Usuarios'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                for (var usuario in usuarios)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PerfilUserView(usuario:usuario),
                            ),
                          );
                    },
                    child: Card(
                      child: ListTile(
                          title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(
                              'Usuario: ${usuario['nombres']} ${usuario['apellidos']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text(
                              "Celular: ${usuario['celular']}",
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "Correo: ${usuario['cuenta']['correo']}",
                              style: TextStyle(fontSize: 16),
                            ),
                            if (usuario['cuenta']['estado'] == true)
                              Text(
                                "Estado cuenta: Activa",
                                style: TextStyle(fontSize: 16),
                              ),
                            if (usuario['cuenta']['estado'] != true)
                              Text(
                                "Estado cuenta: Suspendida",
                                style: TextStyle(fontSize: 16),
                              ),
                          ])),
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
