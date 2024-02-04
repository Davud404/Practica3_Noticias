'use strict';
var models = require('../models');
var rol = models.rol;
class RolControl {
    async listar(req, res) {
        var lista = await rol.findAll({
            attributes: ['nombre', 'external_id'] //para que solo muestre los atributos que le envíes
            //attributes: ['nombre', ['external_id', 'id']] //para que cambie el nombre con el que se muestra el atributo
        });
        res.status(200);
        res.json({ msg: "OK", code: 200, datos: lista });
    }

    async guardar(req, res) {
        if (req.body.hasOwnProperty('nombre')) {//Valida que el nombre del atributo del body esté bien
            var uuid = require('uuid');
            var data = {
                nombre: req.body.nombre,
                external_id: uuid.v4()
            }
            var result = await rol.create(data);
            if (result === null) {
                res.status(401);
                res.json({ msg: "Error", tag: "No se creó", code: 401 });
            } else {
                res.status(200);
                res.json({ msg: "OK", code: 200 });
            }
        } else {
            res.status(400);
            res.json({ msg: "Error", tag: "Faltan datos", code: 400 });
        }
    }

}
module.exports = RolControl; //Exportar la clase            