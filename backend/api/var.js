const ProfileController3 = require("../controllers/variables");
const express = require("express");
var authorize = require('../controllers/permisos')

// API routes
const router = express.Router();


router.get("/all", ProfileController3.findAllVars);

module.exports = router;
