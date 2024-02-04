'use strict';

module.exports = (sequelize, DataTypes) =>{
    const noticia = sequelize.define('noticia',{ //Primero el nombre de la clase y entre llaves sus atributos
        titulo: {type: DataTypes.STRING(100), defaultValue:"NONE"},
        cuerpo: {type: DataTypes.TEXT, defaultValue:"NONE"},
        fecha: {type: DataTypes.DATE, defaultValue:DataTypes.NOW},
        archivo: {type: DataTypes.STRING(150), allowNull:true},
        tipo_Archivo :{type: DataTypes.ENUM('Imagen','Video'), defaultValue:"Imagen"},
        tipo :{type: DataTypes.ENUM('Normal','Deportiva','Urgente','Social','Tecnológica'), defaultValue:"Normal"},
        estado:{type: DataTypes.BOOLEAN, defaultValue:true},
        external_id:{type:DataTypes.UUID, defaultValue: DataTypes.UUIDV4}
    },{freezeTableName: true});
    noticia.associate = function(models){
        noticia.hasMany(models.comentario,{foreignKey:'id_noticia', as:'comentario'}); //relacion 1 a muchos
        noticia.belongsTo(models.persona,{foreignKey:'id_persona'});
    }
    return noticia;
}