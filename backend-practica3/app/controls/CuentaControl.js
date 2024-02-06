'use strict';
var models = require('../models');
var persona = models.persona;
var rol = models.rol;
var cuenta = models.cuenta;
let jwt = require('jsonwebtoken');
class CuentaControl {
    //npm install jsonwebtoken --save 
    //npm install dotenv --save
    async inicio_sesion(req, res){ //Inicio de sesión es post
        if(req.body.hasOwnProperty('correo') &&
        req.body.hasOwnProperty('clave')){
            let cuentaA = await cuenta.findOne({
                where:{correo:req.body.correo},
                include:[
                    {model: models.persona, as:"persona", attributes: ['nombres','apellidos', 'external_id','id_rol']}
                ]
            });
            if(cuentaA === null || cuentaA === undefined){
                res.status(400);
                res.json({msg:"ERROR", tag:"La cuenta no existe", code:400});
            }else{
                if(cuentaA.estado == true){
                    if(cuentaA.clave === req.body.clave){
                        //TODO agregar el rol
                        const token_data ={
                            external: cuentaA.external_id,
                            check:true
                        };
                        require('dotenv').config();
                        const key = process.env.TWICE //Esta es la llave guardada en el env y puede tener cualquier nombre
                        //Escoger uno que no sea tan obvio
                        const token = jwt.sign(token_data, key,{//Encripta el token_data con el abecedario que se le dio (key)
                            expiresIn: '2h'//tiempo de expiración del token
                        });
                        var rolAux = await rol.findOne({where:{id:cuentaA.persona.id_rol}});
                        //console.log(rolAux);
                        var info = {
                            token: token,
                            user: cuentaA.persona.nombres+' '+cuentaA.persona.apellidos,
                            external_user: cuentaA.persona.external_id,
                            rol_user: rolAux.nombre
                        };
                        console.log(cuentaA.persona.external_id);
                        res.status(200);
                        res.json({msg:"OK", tag:"Ha iniciado sesión", code:200, datos:info});
                    }else{
                        res.status(400);
                        res.json({msg:"ERROR", tag:"El correo o clave están incorrectos", code:400});
                    }
                }else{
                    res.status(400);
                    res.json({msg:"ERROR", tag:"La cuenta no está activa", code:400});
                }
            }
        }else{
            res.status(400);
            res.json({msg:"ERROR", tag:"Faltan datos", code:400});
        }
    }
}
module.exports = CuentaControl;