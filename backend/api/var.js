const ProfileController3 = require("../controllers/variables");
const express = require("express");


// API routes
const router = express.Router();


router.get("/all", ProfileController3.findAllVars);

module.exports = router;
