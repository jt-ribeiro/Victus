const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const videoController = require('../controllers/videoController');

// Auth routes
router.post('/auth/login', authController.login);
router.post('/auth/register', authController.register);

// Video routes
router.get('/videos', videoController.getAllVideos);
router.get('/videos/:id', videoController.getVideoById);
router.get('/videos/category/:categoryId', videoController.getVideosByCategory);
router.post('/videos/:id/favorite', videoController.toggleFavorite);
router.put('/videos/:id/position', videoController.updatePosition);

module.exports = router;
