var express = require('express');
var router = express.Router();
let jwt = require('jsonwebtoken');
const personaC = require('../app/controls/PersonaControl'); //Hace un constructor de la clase PersonaControl
let personaControl = new personaC(); //Crear el objeto (instanciarlo)
const rolC = require('../app/controls/RolControl');
let rolControl = new rolC();
const noticiaC = require('../app/controls/NoticiaControl'); 
let noticiaControl = new noticiaC();
const cuentaC = require('../app/controls/CuentaControl'); 
let cuentaControl = new cuentaC();
const comentarioC = require('../app/controls/ComentarioControl');
let comentarioControl = new comentarioC();


/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('Probando nodemon');
});
//middleware, para que solo acceda si está logeado
const auth = function middleware(req,res,next){
  const token = req.headers['news-token'];//Como quiero que se llame
  if(token === undefined){
    res.status(401);
    res.json({msg:"ERROR", tag:"Falta token", code:401});
  }else{
    require('dotenv').config();
    const key = process.env.TWICE;
    jwt.verify(token, key, async(err, decoded)=>{
      if(err){
        res.status(401);
        res.json({msg:"ERROR", tag:"Token no válido o expirado", code:401});
      }else{
        console.log(decoded.external);
        const models = require('../app/models');
        const cuenta = models.cuenta;
        const aux = cuenta.findOne({
          where:{external_id:decoded.external}
        });
        if(aux === null){
          res.status(401);
          res.json({msg:"ERROR", tag:"Token no válido", code:401});
        }else{
          //TODO autorización para roles
          next();
        }
        
      }
    });
  }
  //console.log(token);
  //console.log(req);
  //next();
}
//inicio de sesión
router.post('/login', cuentaControl.inicio_sesion);
//api de personas
router.get('/admin/personas', personaControl.listar);//Al ser un listar, tiene que ser GET
router.get('/admin/personas/get/:external', personaControl.obtener);
router.post('/admin/personas/guardar', personaControl.guardar);
router.post('/usuarios/guardar', personaControl.guardar_usuario);
router.patch('/admin/personas/modificar/:external', personaControl.modificar);
//roles
router.get('/admin/rol', rolControl.listar);
router.post('/admin/rol/guardar', rolControl.guardar);
//noticias
router.get('/noticias', noticiaControl.listar_activas);
router.get('/noticias/get/:external', noticiaControl.obtener);
router.post('/admin/noticias/guardar', noticiaControl.guardar);
router.post('/admin/noticias/file/save/:external', noticiaControl.guardarFoto);
router.patch('/admin/noticia/modificar/:external', noticiaControl.modificar);
//comentarios
router.get('/noticias/comentarios/:external', comentarioControl.listar);
router.post('/noticias/comentarios/guardar/:external', comentarioControl.guardar);
router.patch('/noticias/comentario/modificar/:external', comentarioControl.modificar);
router.get('/noticias/comentarios/usuario/:external', comentarioControl.listar_comentariosUser);

module.exports = router;
