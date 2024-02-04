'use strict'
var formidable = require('formidable');//Librería para poder subir archivos -> npm install formidable --save
var models = require('../models');
var noticia = models.noticia;
var fs = require('fs');//Acceder al sistema operativo del servidor para agregar el archivo
var comentario = models.comentario;
var persona = models.persona;
var extensiones = ['jpg', 'png','jpeg'];
var extensionesVideo = ['mp4'];
const tamanioMax = 2 * 1024 * 1024;

class NoticiaControl {
    async listar(req, res) {
        var lista = await noticia.findAll({
            
            attributes: ['titulo', ['external_id', 'id'], 'cuerpo', 'fecha', 'tipo', 'archivo', 'tipo_Archivo', 'estado'],
            include: [
                { model: models.persona, as: 'persona', attributes: ['nombres', 'apellidos'] }
            ]
        });
        res.status(200);
        res.json({ msg: "OK", code: 200, datos: lista });
    }

    async listar_activas(req, res) {
        var lista = await noticia.findAll({
            where: { estado: true },
            attributes: ['titulo', ['external_id', 'id'], 'cuerpo', 'fecha', 'tipo', 'archivo', 'tipo_Archivo', 'estado'],
            include: [
                { model: models.persona, as: 'persona', attributes: ['nombres', 'apellidos'] }
            ]
        });
        res.status(200);
        res.json({ msg: "OK", code: 200, datos: lista });
    }

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
    }

    async guardar(req, res) {
        if (req.body.hasOwnProperty('titulo') &&
            req.body.hasOwnProperty('cuerpo') &&
            req.body.hasOwnProperty('fecha') &&
            req.body.hasOwnProperty('tipo') &&
            req.body.hasOwnProperty('persona')) {
            var uuid = require('uuid');
            var personaAux = await persona.findOne({
                where: { external_id: req.body.persona },
                include: [{ model: models.rol, as: "rol", attributes: ['nombre'] }], //Para enviar el rol de la persona
            });
            if (personaAux == undefined || personaAux == null) {
                res.status(401);
                res.json({ msg: "Error", tag: "No se encontró al editor", code: 401 });
            } else {
                var data = {
                    titulo: req.body.titulo,
                    cuerpo: req.body.cuerpo,
                    fecha: req.body.fecha,
                    tipo: req.body.tipo,
                    archivo: 'noticia.png',
                    id_persona: personaAux.id,
                    estado: true,
                    external_id: uuid.v4()
                }

                if (personaAux.rol.nombre == 'editor') { //Para que verifique si la persona es un editor
                    var result = await noticia.create(data);
                    if (result === null) {
                        res.status(401);
                        res.json({ msg: "Error", tag: "No se creó", code: 401 });
                    } else {
                        personaAux.external_id = uuid.v4();
                        await personaAux.save();
                        res.status(200);
                        res.json({ msg: "OK", code: 200 });
                    }
                } else {
                    res.status(400);
                    res.json({ msg: "Error", tag: "La persona que ingresa la noticia no es un editor", code: 400 });
                }

            }
        } else {
            res.status(400);
            res.json({ msg: "Error", tag: "Faltan datos", code: 400 });
        }
    }

    async modificar(req, res) {
        const external = req.params.external;
        var notiAux = await noticia.findOne({ where: { external_id: external } });

        if (notiAux == undefined || notiAux == null) {
            res.status(200);
            res.json({ msg: "No existe esa noticia", code: 200, datos: {} });
        } else {
            try {
                var uuid = require('uuid');
                const data = {
                    titulo: req.body.titulo !== undefined ? req.body.titulo : notiAux.titulo,
                    cuerpo: req.body.cuerpo !== undefined ? req.body.cuerpo : notiAux.cuerpo,
                    tipo: req.body.tipo !== undefined ? req.body.tipo : notiAux.tipo,
                    estado: req.body.estado !== undefined ? req.body.estado : notiAux.estado,
                    //external_id: uuid.v4()
                };
                await notiAux.update(data);
                res.status(200).json({ msg: "Noticia modificado", code: 200 });
            } catch (error) {
                res.status(500).json({ msg: "Error interno del servidor", code: 500, error_msg: error.message });
            }
        }
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

    }



}

module.exports = NoticiaControl;