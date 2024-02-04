'use strict';

module.exports = (sequelize, DataTypes) =>{
    const cuenta = sequelize.define('cuenta',{ //Primero el nombre de la clase y entre llaves sus atributos
        correo: {type: DataTypes.STRING(100), unique:true},
        clave: {type: DataTypes.STRING(100), allowNull:false},
        estado: {type: DataTypes.BOOLEAN, defaultValue:true},
        external_id:{type:DataTypes.UUID, defaultValue: DataTypes.UUIDV4}
    },{freezeTableName: true});
    cuenta.associate = function(models){
        cuenta.belongsTo(models.persona,{foreignKey:'id_persona'});//Relacional bidireccional 1 a 1
    }
    return cuenta;
}