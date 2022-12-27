const UserController = require("../controllers/users");
const express = require("express");



// API routes
const router = express.Router();


//llamar usuario por id
router.get("/:id", UserController.findById);

module.exports = router;