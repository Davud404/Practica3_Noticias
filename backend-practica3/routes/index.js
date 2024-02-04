var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
//request es la petición que hace (get o post), response es la respuesta a esa petición (html o lo que sea)
  res.render('index', { title: 'Express' });
});

router.get('/hola', function(req, res, next) {
  console.log(req);
  res.send({"data":"hola"});//respuesta a la solicitud
  //res.render('index', { title: 'Express' });
});

router.get('/hola/:name/:last/user', function(req, res, next) {//se pone ":" para indicar que recibe parámetros
  console.log(req.params);//params solo sirve para get, no para post
  res.send({"data":"hola con parametros get"});//respuesta a la solicitud
  //res.render('index', { title: 'Express' });
});

router.post('/hola/pos', function(req, res, next) {//se pone ":" para indicar que recibe parámetros
  console.log(req);
  res.send({"data":"hola con post"});//respuesta a la solicitud
  //res.render('index', { title: 'Express' });
});

module.exports = router;
