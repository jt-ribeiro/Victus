const db = require('../config/db');

// Get all courses with user progress
exports.getAllCourses = async (req, res) => {
    try {
        const userId = req.user.id;

        const [courses] = await db.query(
            `SELECT 
        c.id,
        c.title,
        c.description,
        c.thumbnail_url,
        c.thumbnail_color,
        c.status,
        COALESCE(uc.progress_percentage, 0) as progress_percentage,
        COALESCE(uc.is_favorite, FALSE) as is_favorite
       FROM courses c
       LEFT JOIN user_courses uc ON c.id = uc.course_id AND uc.user_id = ?
       ORDER BY c.order_index ASC`,
            [userId]
        );

        res.json({
            success: true,
            data: courses
        });

    } catch (error) {
        console.error('Get courses error:', error);
        res.status(500).json({
            success: false,
            message: 'Erro ao carregar cursos'
        });
    }
};

// Get course details with lessons
exports.getCourseById = async (req, res) => {
    try {
        const userId = req.user.id;
        const courseId = req.params.id;

        // Get course info
        const [courses] = await db.query(
            `SELECT 
        c.id,
        c.title,
        c.description,
        c.thumbnail_url,
        c.thumbnail_color,
        c.status,
        COALESCE(uc.progress_percentage, 0) as progress_percentage,
        COALESCE(uc.is_favorite, FALSE) as is_favorite
       FROM courses c
       LEFT JOIN user_courses uc ON c.id = uc.course_id AND uc.user_id = ?
       WHERE c.id = ?`,
            [userId, courseId]
        );

        if (courses.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Curso não encontrado'
            });
        }

        const course = courses[0];

        // Get lessons for this course
        const [lessons] = await db.query(
            `SELECT 
        l.id,
        l.title,
        l.description,
        l.video_url,
        l.thumbnail_url,
        l.duration_seconds,
        l.order_index,
        l.is_free,
        COALESCE(ul.is_completed, FALSE) as is_completed,
        COALESCE(ul.is_favorite, FALSE) as is_favorite,
        COALESCE(ul.is_liked, FALSE) as is_liked,
        COALESCE(ul.last_position_seconds, 0) as last_position_seconds
       FROM lessons l
       LEFT JOIN user_lessons ul ON l.id = ul.lesson_id AND ul.user_id = ?
       WHERE l.course_id = ?
       ORDER BY l.order_index ASC`,
            [userId, courseId]
        );

        res.json({
            success: true,
            data: {
                ...course,
                lessons
            }
        });

    } catch (error) {
        console.error('Get course error:', error);
        res.status(500).json({
            success: false,
            message: 'Erro ao carregar curso'
        });
    }
};

// Get lesson details
exports.getLessonById = async (req, res) => {
    try {
        const userId = req.user.id;
        const lessonId = req.params.id;

        const [lessons] = await db.query(
            `SELECT 
        l.id,
        l.course_id,
        l.title,
        l.description,
        l.video_url,
        l.thumbnail_url,
        l.duration_seconds,
        l.order_index,
        l.is_free,
        COALESCE(ul.is_completed, FALSE) as is_completed,
        COALESCE(ul.is_favorite, FALSE) as is_favorite,
        COALESCE(ul.is_liked, FALSE) as is_liked,
        COALESCE(ul.last_position_seconds, 0) as last_position_seconds
       FROM lessons l
       LEFT JOIN user_lessons ul ON l.id = ul.lesson_id AND ul.user_id = ?
       WHERE l.id = ?`,
            [userId, lessonId]
        );

        if (lessons.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Aula não encontrada'
            });
        }

        res.json({
            success: true,
            data: lessons[0]
        });

    } catch (error) {
        console.error('Get lesson error:', error);
        res.status(500).json({
            success: false,
            message: 'Erro ao carregar aula'
        });
    }
};

// Toggle lesson favorite
exports.toggleLessonFavorite = async (req, res) => {
    try {
        const userId = req.user.id;
        const lessonId = req.params.id;

        // Check if user_lesson record exists
        const [existing] = await db.query(
            'SELECT id, is_favorite FROM user_lessons WHERE user_id = ? AND lesson_id = ?',
            [userId, lessonId]
        );

        if (existing.length > 0) {
            // Update existing record
            const newFavoriteStatus = !existing[0].is_favorite;
            await db.query(
                'UPDATE user_lessons SET is_favorite = ? WHERE user_id = ? AND lesson_id = ?',
                [newFavoriteStatus, userId, lessonId]
            );

            res.json({
                success: true,
                data: { is_favorite: newFavoriteStatus }
            });
        } else {
            // Create new record
            await db.query(
                'INSERT INTO user_lessons (user_id, lesson_id, is_favorite) VALUES (?, ?, TRUE)',
                [userId, lessonId]
            );

            res.json({
                success: true,
                data: { is_favorite: true }
            });
        }

    } catch (error) {
        console.error('Toggle favorite error:', error);
        res.status(500).json({
            success: false,
            message: 'Erro ao atualizar favorito'
        });
    }
};

// Toggle lesson like
exports.toggleLessonLike = async (req, res) => {
    try {
        const userId = req.user.id;
        const lessonId = req.params.id;

        const [existing] = await db.query(
            'SELECT id, is_liked FROM user_lessons WHERE user_id = ? AND lesson_id = ?',
            [userId, lessonId]
        );

        if (existing.length > 0) {
            const newLikeStatus = !existing[0].is_liked;
            await db.query(
                'UPDATE user_lessons SET is_liked = ? WHERE user_id = ? AND lesson_id = ?',
                [newLikeStatus, userId, lessonId]
            );

            res.json({
                success: true,
                data: { is_liked: newLikeStatus }
            });
        } else {
            await db.query(
                'INSERT INTO user_lessons (user_id, lesson_id, is_liked) VALUES (?, ?, TRUE)',
                [userId, lessonId]
            );

            res.json({
                success: true,
                data: { is_liked: true }
            });
        }

    } catch (error) {
        console.error('Toggle like error:', error);
        res.status(500).json({
            success: false,
            message: 'Erro ao atualizar like'
        });
    }
};

// Mark lesson as complete
exports.markLessonComplete = async (req, res) => {
    try {
        const userId = req.user.id;
        const lessonId = req.params.id;

        const [existing] = await db.query(
            'SELECT id, is_completed FROM user_lessons WHERE user_id = ? AND lesson_id = ?',
            [userId, lessonId]
        );

        if (existing.length > 0) {
            const newCompleteStatus = !existing[0].is_completed;
            await db.query(
                'UPDATE user_lessons SET is_completed = ?, completed_at = ? WHERE user_id = ? AND lesson_id = ?',
                [newCompleteStatus, newCompleteStatus ? new Date() : null, userId, lessonId]
            );

            res.json({
                success: true,
                data: { is_completed: newCompleteStatus }
            });
        } else {
            await db.query(
                'INSERT INTO user_lessons (user_id, lesson_id, is_completed, completed_at) VALUES (?, ?, TRUE, NOW())',
                [userId, lessonId]
            );

            res.json({
                success: true,
                data: { is_completed: true }
            });
        }

        // Update course progress
        await updateCourseProgress(userId, lessonId);

    } catch (error) {
        console.error('Mark complete error:', error);
        res.status(500).json({
            success: false,
            message: 'Erro ao marcar como completa'
        });
    }
};

// Update video position
exports.updateVideoPosition = async (req, res) => {
    try {
        const userId = req.user.id;
        const lessonId = req.params.id;
        const { position_seconds } = req.body;

        const [existing] = await db.query(
            'SELECT id FROM user_lessons WHERE user_id = ? AND lesson_id = ?',
            [userId, lessonId]
        );

        if (existing.length > 0) {
            await db.query(
                'UPDATE user_lessons SET last_position_seconds = ? WHERE user_id = ? AND lesson_id = ?',
                [position_seconds, userId, lessonId]
            );
        } else {
            await db.query(
                'INSERT INTO user_lessons (user_id, lesson_id, last_position_seconds) VALUES (?, ?, ?)',
                [userId, lessonId, position_seconds]
            );
        }

        res.json({
            success: true,
            data: { last_position_seconds: position_seconds }
        });

    } catch (error) {
        console.error('Update position error:', error);
        res.status(500).json({
            success: false,
            message: 'Erro ao atualizar posição'
        });
    }
};

// Helper function to update course progress
async function updateCourseProgress(userId, lessonId) {
    try {
        // Get course_id from lesson
        const [lessons] = await db.query(
            'SELECT course_id FROM lessons WHERE id = ?',
            [lessonId]
        );

        if (lessons.length === 0) return;

        const courseId = lessons[0].course_id;

        // Calculate progress
        const [totalLessons] = await db.query(
            'SELECT COUNT(*) as total FROM lessons WHERE course_id = ?',
            [courseId]
        );

        const [completedLessons] = await db.query(
            `SELECT COUNT(*) as completed 
       FROM user_lessons ul
       JOIN lessons l ON ul.lesson_id = l.id
       WHERE ul.user_id = ? AND l.course_id = ? AND ul.is_completed = TRUE`,
            [userId, courseId]
        );

        const progressPercentage = (completedLessons[0].completed / totalLessons[0].total) * 100;

        // Update or create user_course record
        const [existingCourse] = await db.query(
            'SELECT id FROM user_courses WHERE user_id = ? AND course_id = ?',
            [userId, courseId]
        );

        if (existingCourse.length > 0) {
            await db.query(
                'UPDATE user_courses SET progress_percentage = ? WHERE user_id = ? AND course_id = ?',
                [progressPercentage, userId, courseId]
            );
        } else {
            await db.query(
                'INSERT INTO user_courses (user_id, course_id, progress_percentage) VALUES (?, ?, ?)',
                [userId, courseId, progressPercentage]
            );
        }

    } catch (error) {
        console.error('Update course progress error:', error);
    }
}

module.exports = exports;
