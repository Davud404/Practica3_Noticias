import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend_practica3/controls/servicio_back/FacadeService.dart';
import 'package:frontend_practica3/controls/utiles/Utiles.dart';
import 'package:validators/validators.dart';

class SessionView extends StatefulWidget {
  const SessionView({ Key? key }) : super(key: key);

  @override
  _SessionViewState createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  final _formKey = GlobalKey<FormState>(); //El guión bajo indica que la variable es privada
  final TextEditingController correoControl = TextEditingController();
  final TextEditingController claveControl = TextEditingController();
  void _iniciar(){
    setState(() {
      FacadeService servicio = FacadeService();
      if(_formKey.currentState!.validate()){
        Map<String, String> mapa = {
          "correo":correoControl.text,
          "clave": claveControl.text
        };
        //log(mapa.toString());
        servicio.inicioSesion(mapa).then((value) async {
          if(value.code ==200){
            //log(value.code.toString());
            //log(value.datos['tag']);
            Utiles util = Utiles();
            util.saveValue('token', value.datos['token']);
            util.saveValue('user', value.datos['user']);
            util.saveValue('external', value.datos['external_user']);
            util.saveValue('rol', value.datos['rol_user']);
            final SnackBar msg = SnackBar(content: Text('Bienvenido ${value.datos['user']}'));
            ScaffoldMessenger.of(context).showSnackBar(msg);
          }else{
            final SnackBar msg = SnackBar(content: Text('Error ${value.tag}'));
            ScaffoldMessenger.of(context).showSnackBar(msg);
          }
        });
        Navigator.pushNamed(context, '/noticias');
      }else{
        log("okn't");
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key : _formKey,
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(32),
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text("Noticias", 
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize :30
              )),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: correoControl,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  suffixIcon: Icon(Icons.alternate_email)
                ),
                validator:(value){
                  if(value!.isEmpty){
                    return "Debe ingresar su correo";
                  }
                  if(!isEmail(value)){
                    return "Ingrese un correo válido";
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                obscureText: true,
                controller: claveControl,
                decoration: const InputDecoration(
                  labelText: 'Clave',
                  suffixIcon: Icon(Icons.key)
                ),
                validator:(value){
                  if(value!.isEmpty){
                    return "Debe ingresar su clave";
                  }
                },
              ),
            ),
            Container(
              height:50,
              padding: const EdgeInsets.fromLTRB(10,0,10,0), //Función para padding de todos lados Left, Top, Right, Bottom
              child: ElevatedButton(
                child: const Text("Inicio"),
                onPressed: _iniciar,
              ),
            ),
            Row(
              children: <Widget>[
                const Text('No tienes una cuenta!'),
                TextButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/register');//Routers
                  }, 
                  child: const Text(
                    'Registrarse',
                    style: TextStyle(fontSize: 20),
                  ))
              ],),
          ],
        ),
      ),
    );
  }
}