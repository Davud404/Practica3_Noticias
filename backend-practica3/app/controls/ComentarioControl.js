'use strict'
var formidable = require('formidable');//Librería para poder subir archivos -> npm install formidable --save
var models = require('../models');
var noticia = models.noticia;
var fs = require('fs');//Acceder al sistema operativo del servidor para agregar el archivo
var comentario = models.comentario;
var persona = models.persona;

class ComentarioControl {
    
    async listar(req, res) {
        const external = req.params.external;
        var noticiaAux = await noticia.findOne({ where: { external_id: external } });
        if (noticiaAux === undefined || noticiaAux === null) {
            res.status(400);
            res.json({ msg: "Error", tag: "No existe esa noticia", code: 400 });
        } else {
            var lista = await comentario.findAll({
                where: { id_noticia: noticiaAux.id },
                attributes: ['cuerpo', 'estado', 'fecha', 'latitud', 'longitud', 'external_id'],
                include: [
                    { model: models.noticia, as: 'noticia', attributes: ['titulo'] },
                    { model: models.persona, as: 'persona', attributes: ['nombres', 'apellidos'] }
                ]
            });
            res.status(200);
            res.json({ msg: "OK", code: 200, datos: lista });
        }
    }
    /*
    async obtener(req, res) {
        const external = req.params.external;
        var lista = await noticia.findOne({
            where: { external_id: external },
            attributes: ['titulo', ['external_id', 'id'], 'cuerpo', 'fecha', 'tipo', 'archivo', 'tipo_Archivo', 'estado'],
            include: [
                { model: models.persona, as: 'persona', attributes: ['nombres', 'apellidos'] }
            ]
        });
        if (lista === undefined || lista == null) {
            res.status(200);
            res.json({ msg: "No hay noticias", code: 200, datos: {} });
        } else {
            res.status(200);
            res.json({ msg: "OK", code: 200, datos: lista });
        }
    }*/

    async guardar(req, res) {
        const external = req.params.external;
        var noticiaAux = await noticia.findOne({ where: { external_id: external } });
        if (noticiaAux != undefined || noticiaAux != null) {
            if (req.body.hasOwnProperty('cuerpo') &&
                req.body.hasOwnProperty('longitud') &&
                req.body.hasOwnProperty('latitud') &&
                req.body.hasOwnProperty('fecha')) {
                var uuid = require('uuid');
                var usuarioAux = await persona.findOne({ where: { external_id: req.body.usuario } });
                if (usuarioAux != null || usuarioAux != undefined) {
                    var data = {
                        cuerpo: req.body.cuerpo,
                        fecha: req.body.fecha,
                        estado: 1,
                        id_noticia: noticiaAux.id,
                        longitud: req.body.longitud,
                        latitud: req.body.latitud,
                        id_persona: usuarioAux.id,
                        external_id: uuid.v4()
                    }
                    var result = await comentario.create(data);
                    if (result === null) {
                        res.status(401);
                        res.json({ msg: "Error", tag: "No se registró el comentario", code: 401 });
                    } else {
                        res.status(200);
                        res.json({ msg: "OK", code: 200 });
                    }
                } else {
                    res.status(400);
                    res.json({ msg: "Error", tag: "No existe ese usuario", code: 400 });
                }


            } else {
                res.status(400);
                res.json({ msg: "Error", tag: "Faltan datos", code: 400 });
            }
        } else {
            res.status(400);
            res.json({ msg: "Error", tag: "No existe esa noticia", code: 400 });
        }
    }

    async modificar(req, res) {
        const external = req.params.external;
        var coment = await comentario.findOne({ where: { external_id: external } });

        if (coment == undefined || coment == null) {
            res.status(200);
            res.json({ msg: "No existe ese comentario", code: 200, datos: {} });
        } else {
            try {
                var uuid = require('uuid');
                const data = {
                    cuerpo: req.body.cuerpo !== undefined ? req.body.cuerpo : coment.cuerpo,
                    fecha: req.body.fecha !== undefined ? req.body.fecha : coment.fecha,
                    estado: req.body.estado !== undefined ? req.body.estado : coment.estado,
                    longitud: req.body.longitud !== undefined ? req.body.longitud : coment.longitud,
                    latitud: req.body.latitud !== undefined ? req.body.latitud : coment.latitud,
                    external_id: uuid.v4()
                };
                await coment.update(data);
                res.status(200).json({ msg: "Comentario modificado", code: 200 });
            } catch (error) {
                res.status(500).json({ msg: "Error interno del servidor", code: 500, error_msg: error.message });
            }
        }

    }

    /*
        async modificar(req, res) {
            
        }
        //actualizar foto de la noticia usando el external
        async guardarFoto(req, res) {
            const externalNoticia = req.params.external;
            var form = new formidable.IncomingForm(), files = [];
            form.on('file', function (field, file) {//Siempre enviar este dato como file en el formulario, si es archivo, acá también será archivo inputFile
                files.push(file);
            }).on('end', function () {
                console.log('OK');
            });
            //TODO: Validar tamaño y tipo de archivo, máximo 2 megas
            form.parse(req, function (err, fields) {
                let listado = files;
                //let body = JSON.parse(fields);
                let external = fields.external[0];
                for (let index = 0; index < listado.length; index++) {
                    var file = listado[index];
                    //validación del tamaño y tipo de archivo
                    var extension = file.originalFilename.split('.').pop().toLowerCase();//Sacar el nombre original del archivo (archivo.png), separa en puntos y los pone en pilas. Saca la primera posición que sería el formato del archivo
                    //console.log(file);
                    if (file.size > tamanioMax) {
                        res.status(400);
                        res.json({ msg: "ERROR", tag: "El tamaño del archivo supera los 2MB ", code: 400 });
                    } else {
                        if (extensiones.includes(extension) || extensionesVideo.includes(extension)) {
                            const name = external + '.' + extension;//Dándole al archivo un nombre específico
                            console.log(extension);
                            const tipoArchivo = extensiones.includes(extension) ? 'Imagen' : 'Video';
                            fs.rename(file.filepath, "public/multimedia/" + name, async function (err) {//guardar el archivo en la carpeta
                                if (err) {
                                    res.status(200);
                                    res.json({ msg: "Error", tag: "No se pudo guardar el archivo", code: 200 });
                                } else {
                                    await noticia.update({archivo:name, tipo_Archivo:tipoArchivo},{where:{external_id:externalNoticia}});
                                    res.status(200);
                                    res.json({ msg: "OK", tag: "Archivo guardado", code: 200 });
                                    
                                }
                            });
                        } else {
                            res.status(400);
                            res.json({ msg: "ERROR", tag: "Solo soporta " + extensiones+" o "+extensionesVideo, code: 400 });
                        }
                    }
    
                }
            });
    
        }*/



}

module.exports = ComentarioControl;