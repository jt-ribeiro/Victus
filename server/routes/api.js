const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const dashboardController = require('../controllers/dashboardController');
const courseController = require('../controllers/courseController');
const authMiddleware = require('../middleware/auth');

// =====================================================
// PUBLIC ROUTES (No authentication required)
// =====================================================

// Auth routes
router.post('/auth/login', authController.login);
router.post('/auth/register', authController.register);

// =====================================================
// PROTECTED ROUTES (Authentication required)
// =====================================================

// User profile
router.get('/auth/profile', authMiddleware, authController.getProfile);

// Dashboard
router.get('/dashboard', authMiddleware, dashboardController.getDashboard);
router.get('/events', authMiddleware, dashboardController.getEvents);

// Courses & Library
router.get('/courses', authMiddleware, courseController.getAllCourses);
router.get('/courses/:id', authMiddleware, courseController.getCourseById);

// Lessons
router.get('/lessons/:id', authMiddleware, courseController.getLessonById);
router.post('/lessons/:id/favorite', authMiddleware, courseController.toggleLessonFavorite);
router.post('/lessons/:id/like', authMiddleware, courseController.toggleLessonLike);
router.post('/lessons/:id/complete', authMiddleware, courseController.markLessonComplete);
router.put('/lessons/:id/position', authMiddleware, courseController.updateVideoPosition);

module.exports = router;
