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
  const EditarPerfil({Key? key, required this.persona}) : super(key: key);

  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombres = TextEditingController();
  final TextEditingController apellidos = TextEditingController();
  final TextEditingController celular = TextEditingController();
  final TextEditingController correo = TextEditingController();

  @override
  void initState() {
    super.initState();
    nombres.text = widget.persona['nombres'];
    apellidos.text = widget.persona['apellidos'];
    celular.text = widget.persona['celular'];
    correo.text = widget.persona['cuenta']['correo'];
  }

  void _modificar() {
    setState(() {
      FacadeService servicio = FacadeService();
      if (_formKey.currentState!.validate()) {
        Map<String, String> mapa = {
          "nombres": nombres.text,
          "apellidos": apellidos.text,
          "celular": celular.text,
          "correo": correo.text,
        };
        servicio
            .modificarUsuario(widget.persona['external_id'], mapa)
            .then((value) async {
          if (value.code == 200) {
            log('modificado');
            Utiles util = Utiles();
            util.removeItem('user');
            final String user = nombres.text + " " + apellidos.text;
            util.saveValue('user', user);
          } else {
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
          title: Text('Editar Perfil'),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: nombres,
                decoration: const InputDecoration(
                    labelText: 'Nombres', suffixIcon: Icon(Icons.emoji_people)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Ingrese sus nombres";
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: apellidos,
                decoration: const InputDecoration(
                    labelText: 'Apellidos',
                    suffixIcon: Icon(Icons.emoji_people)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Ingrese sus apellidos";
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: celular,
                decoration: const InputDecoration(
                    labelText: 'Celular', suffixIcon: Icon(Icons.add_ic_call)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Ingrese su celular";
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: correo,
                decoration: const InputDecoration(
                    labelText: 'Correo',
                    suffixIcon: Icon(Icons.alternate_email)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Ingrese un correo";
                  }
                  if (!isEmail(value)) {
                    return "Ingrese un correo válido";
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                    onPressed: () {
                      _modificar();
                      Navigator.pushNamed(context, '/noticias');
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: const Text(
                      'Confirmar',
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
