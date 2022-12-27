const mongoose = require("mongoose");
const Vars = require('../models/Var');


// buscar todas las variables
const findAllVars = (req, res) => {
    Vars.find((err, users) => {
    err && res.status(500).send(err.message);
    res.status(200).json(users);
    });
};
  
module.exports = { findAllVars};
