const express = require('express');
const loginRouter = require('../config/auth/login');

const router = express.Router();

router.use('/auth', loginRouter); // all auth routes start with /auth

module.exports = router;
