import 'package:frontend_practica3/controls/servicio_back/RespuestaGenerica.dart';

class InicioSesion extends RespuestaGenerica{
  String tag='';
  InicioSesion({msg='', code=0, datos, this.tag=''});
}