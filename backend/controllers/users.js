const mongoose = require("mongoose");
const User = require("../models/User");

//funcion para llamar a todos los usuarios
    const findAllUsers = (req, res) => {
        User.find((err, users) => {
        err && res.status(500).send(err.message);
        res.status(200).json(users);
        });
    };

//funcion para llamar a un solo usuario por la id 
  const findById = (req, res) => {
    User.findById(req.params.id, (err, user) => {
        err && res.status(500).send(err.message);
      
  
      res.status(200).json(user);
    });
  };
      
module.exports = { findAllUsers, findById};