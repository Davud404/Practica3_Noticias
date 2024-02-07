'use strict';
var models = require('../models');
var persona = models.persona;
var rol = models.rol;
class PersonaControl {

    async listar(req, res) {
        var lista = await persona.findAll({
            attributes: ['nombres', 'apellidos', 'celular', 'external_id'],
            include: [
                { model: models.cuenta, as: 'cuenta', attributes: ['correo'] },
                { model: models.rol, as: 'rol', attributes: ['nombre'] }
            ]
        });
        res.status(200);
        res.json({ msg: "OK", code: 200, datos: lista });
    }

    async obtener(req, res) {
        const external = req.params.external;
        var lista = await persona.findOne({
            where: { external_id: external },
            attributes: ['nombres', 'apellidos', 'celular', 'external_id'],
            include: [
                { model: models.cuenta, as: 'cuenta', attributes: ['correo'] },
                { model: models.rol, as: 'rol', attributes: ['nombre'] }
            ]
        });
        if (lista === undefined || lista == null) {
            res.status(200);
            res.json({ msg: "No hay nada", code: 200, datos: {} });
        } else {
            res.status(200);
            res.json({ msg: "OK", code: 200, datos: lista });
        }

    }

    async guardar(req, res) {
        if (req.body.hasOwnProperty('nombres') &&
            req.body.hasOwnProperty('apellidos') &&
            req.body.hasOwnProperty('direccion') &&
            req.body.hasOwnProperty('celular') &&
            req.body.hasOwnProperty('fecha') &&
            req.body.hasOwnProperty('correo') &&
            req.body.hasOwnProperty('clave') &&
            req.body.hasOwnProperty('rol')) {
            var uuid = require('uuid');
            var rolAux = await rol.findOne({ where: { external_id: req.body.rol } }); //Busca el objeto rol con el mismo external_id y lo asigna a rolAux
            if (rolAux != undefined) {
                var data = {
                    apellidos: req.body.apellidos,
                    nombres: req.body.nombres,
                    direccion: req.body.direccion,
                    celular: req.body.celular,
                    fecha_nacimiento: req.body.fecha,
                    id_rol: rolAux.id,
                    external_id: uuid.v4(),
                    cuenta: {
                        correo: req.body.correo,
                        clave: req.body.clave
                    }
                }
                let transaction = await models.sequelize.transaction();
                try {
                    var result = await persona.create(data, { include: [{ model: models.cuenta, as: "cuenta" }], transaction });//Incluir modelos con los que se relaciona
                    //Con transaction se asegura de que si hay un error, haga un rollback y no guarde nada
                    await transaction.commit();
                    if (result === null) {
                        res.status(401);
                        res.json({ msg: "Error", tag: "No se creó", code: 401 });
                    } else {
                        rolAux.external_id = uuid.v4();
                        await rolAux.save();
                        res.status(200);
                        res.json({ msg: "OK", code: 200 });
                    }
                } catch (error) {
                    if (transaction) await transaction.rollback(); //Si pasa algo, hace rollback y no guarda nada
                    res.status(203);
                    res.json({ msg: "Error", code: 203, error_msg: error });
                }

            } else {
                res.status(400);
                res.json({ msg: "Error", tag: "El rol no existe", code: 400 });
            }
        } else {
            res.status(400);
            res.json({ msg: "Error", tag: "Faltan datos", code: 400 });
        }
    }

    async guardar_usuario(req, res) {
        if (req.body.hasOwnProperty('nombres') &&
            req.body.hasOwnProperty('apellidos') &&
            req.body.hasOwnProperty('direccion') &&
            req.body.hasOwnProperty('celular') &&
            req.body.hasOwnProperty('fecha') &&
            req.body.hasOwnProperty('correo') &&
            req.body.hasOwnProperty('clave')) {
            var uuid = require('uuid');
            var rolAux = await rol.findOne({ where: { nombre: "usuario" } });
            var data = {
                apellidos: req.body.apellidos,
                nombres: req.body.nombres,
                direccion: req.body.direccion,
                celular: req.body.celular,
                fecha_nacimiento: req.body.fecha,
                id_rol: rolAux.id,
                external_id: uuid.v4(),
                cuenta: {
                    correo: req.body.correo,
                    clave: req.body.clave
                }
            }
            let transaction = await models.sequelize.transaction();
            try {
                var result = await persona.create(data, { include: [{ model: models.cuenta, as: "cuenta" }], transaction });//Incluir modelos con los que se relaciona
                //Con transaction se asegura de que si hay un error, haga un rollback y no guarde nada 
                await transaction.commit();
                if (result === null) {
                    res.status(401);
                    res.json({ msg: "Error", tag: "No se creó", code: 401 });
                } else {
                    res.status(200);
                    res.json({ msg: "OK", code: 200 });
                }
            } catch (error) {
                if (transaction) await transaction.rollback(); //Si pasa algo, hace rollback y no guarda nada
                res.status(203);
                res.json({ msg: "Error", code: 203, error_msg: error });
            }

        } else {
            res.status(400);
            res.json({ msg: "Error", tag: "Faltan datos", code: 400 });
        }
    }

    async modificar(req, res) {
        const external = req.params.external;
        var person = await persona.findOne({
            where: { external_id: external },
            include: [
                { model: models.cuenta, as: 'cuenta' },
                { model: models.rol, as: 'rol' }
            ]
        });

        if (person == undefined || person == null) {
            res.status(200).json({ msg: "No existe esa persona", code: 200 });
        } else {
            try {
                var uuid = require('uuid');

                const data = {
                    apellidos: req.body.apellidos !== undefined ? req.body.apellidos : person.apellidos,
                    nombres: req.body.nombres !== undefined ? req.body.nombres : person.nombres,
                    celular: req.body.celular !== undefined ? req.body.celular : person.celular,
                    fecha_nacimiento: req.body.fecha !== undefined ? req.body.fecha : person.fecha_nacimiento,
                    //id_rol: req.body.rol !== undefined ? req.body.rol.id : person.rol.id,
                    //external_id: uuid.v4()
                };
                if (req.body.correo !== undefined || req.body.clave !== undefined) {
                    data.cuenta = {
                        correo: req.body.correo !== undefined ? req.body.correo : person.cuenta.correo,
                        clave: req.body.clave !== undefined ? req.body.clave : person.cuenta.clave
                    };
                }
                if (req.body.rol !== undefined) {
                    var rolAux = await rol.findOne({ where: { external_id: req.body.rol } });
                    data.id_rol = rolAux.id;
                    rolAux.external_id = uuid.v4();
                    await rolAux.save();
                }
                await person.update(data);
                res.status(200).json({ msg: "Persona modificada", code: 200 });
            } catch (error) {
                res.status(500).json({ msg: "Error interno del servidor", code: 500, error_msg: error.message });
            }
        }

    }
}
module.exports = PersonaControl; //Exportar la clase