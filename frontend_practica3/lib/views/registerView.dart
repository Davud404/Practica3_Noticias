import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend_practica3/controls/servicio_back/FacadeService.dart';
import 'package:frontend_practica3/controls/utiles/Utiles.dart';
import 'package:validators/validators.dart';

//fstful
class RegisterView extends StatefulWidget {
  const RegisterView({ Key? key }) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nombres = TextEditingController();
    final TextEditingController apellidos = TextEditingController();
    final TextEditingController celular = TextEditingController();
    final TextEditingController direccion = TextEditingController();
    final TextEditingController fecha_nacimiento = TextEditingController();
    final TextEditingController correo = TextEditingController();
    final TextEditingController clave = TextEditingController();

    void _registrar(){
      setState(() {
        FacadeService servicio = FacadeService();
        if(_formKey.currentState!.validate()){
          Map<String, String> mapa = {
            "nombres": nombres.text,
            "apellidos": apellidos.text,
            "celular": celular.text,
            "direccion": direccion.text,
            "fecha": fecha_nacimiento.text,
            "correo": correo.text,
            "clave": clave.text,
          };
          //log(mapa.toString());
          servicio.registrarUsuario(mapa).then((value) async{
            log(value.msg);
            if(value.code == 200){
              log('registrado');
            }else{
              log('no se pudo');
            }
          });
        }
      });
    }

    return Form(
      key: _formKey,
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text("Registro de Usuarios", 
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize :30
              )),
            ),
            Container(
              alignment: Alignment.center,

            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: nombres,
                decoration: const InputDecoration(
                  labelText: 'Nombres',
                  suffixIcon: Icon(Icons.alternate_email)
                ),
                validator:(value){
                  if(value!.isEmpty){
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
                  suffixIcon: Icon(Icons.alternate_email)
                ),
                validator:(value){
                  if(value!.isEmpty){
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
                  labelText: 'Celular',
                  suffixIcon: Icon(Icons.alternate_email)
                ),
                validator:(value){
                  if(value!.isEmpty){
                    return "Ingrese su numero de celular";
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: direccion,
                decoration: const InputDecoration(
                  labelText: 'Direccion',
                  suffixIcon: Icon(Icons.alternate_email)
                ),
                validator:(value){
                  if(value!.isEmpty){
                    return "Ingrese su numero de celular";
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: fecha_nacimiento,
                decoration: const InputDecoration(
                  labelText: 'Fecha de nacimiento',
                  suffixIcon: Icon(Icons.alternate_email)
                ),
                validator:(value){
                  if(value!.isEmpty){
                    return "Ingrese su fecha de nacimiento";
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
                  suffixIcon: Icon(Icons.alternate_email)
                ),
                validator:(value){
                  if(value!.isEmpty){
                    return "Ingrese un correo";
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
                controller: clave,
                decoration: const InputDecoration(
                  labelText: 'Clave',
                  suffixIcon: Icon(Icons.alternate_email)
                ),
                validator:(value){
                  if(value!.isEmpty){
                    return "Ingrese una clave";
                  }
                },
              ),
            ),
            Container(
              height:50,
              padding: const EdgeInsets.fromLTRB(10,0,10,0), //Función para padding de todos lados Left, Top, Right, Bottom
              child: ElevatedButton(
                child: const Text("Registrar"),
                onPressed: _registrar,
              ),
            ),
            Row(
              children: <Widget>[
                const Text('Ya tienes una cuenta!'),
                TextButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/home');//Routers
                  }, 
                  child: const Text(
                    'Inicio de sesion',
                    style: TextStyle(fontSize: 20),
                  ))
              ],),
          ],
        ),
      ),
    );
  }
}