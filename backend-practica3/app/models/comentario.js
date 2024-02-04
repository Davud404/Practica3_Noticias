'use strict';

module.exports = (sequelize, DataTypes) =>{
    const comentario = sequelize.define('comentario',{ //Primero el nombre de la clase y entre llaves sus atributos
        cuerpo: {type: DataTypes.TEXT, allowNull:false},
        estado: {type: DataTypes.BOOLEAN, allowNull:false},
        fecha: {type: DataTypes.DATE, defaultValue:DataTypes.NOW},
        longitud: {type: DataTypes.FLOAT, defaultValue: 0.0},
        latitud: {type: DataTypes.FLOAT, defaultValue: 0.0},
        external_id:{type:DataTypes.UUID, defaultValue: DataTypes.UUIDV4}
    },{freezeTableName: true, timestamps:false});
    comentario.associate = function(models){
        comentario.belongsTo(models.noticia, { foreignKey: 'id_noticia', as: 'noticia' });
        comentario.belongsTo(models.persona, { foreignKey: 'id_persona'});
    }
    return comentario;
}