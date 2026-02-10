<?php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../utils/Response.php';

class CourseController
{
    private $db;

    public function __construct()
    {
        $database = new Database();
        $this->db = $database->getConnection();
    }

    // GET /api/courses
    public function getAllCourses()
    {
        $user = getCurrentUser();

        try {
            $stmt = $this->db->prepare("
                SELECT 
                    c.id,
                    c.title,
                    c.description,
                    c.thumbnail_url,
                    c.thumbnail_color,
                    COALESCE(uc.progress_percentage, 0) as progress_percentage,
                    COALESCE(uc.is_favorite, 0) as is_favorite
                FROM courses c
                LEFT JOIN user_courses uc ON c.id = uc.course_id AND uc.user_id = ?
                ORDER BY c.id DESC
            ");
            $stmt->execute([$user->id]);
            $courses = $stmt->fetchAll();

            Response::success($courses);

        } catch (Exception $e) {
            Response::serverError('Erro ao obter cursos: ' . $e->getMessage());
        }
    }

    // GET /api/courses/:id
    public function getCourseById($id)
    {
        $user = getCurrentUser();

        try {
            // Get course details
            $stmt = $this->db->prepare("
                SELECT 
                    c.*,
                    COALESCE(uc.progress_percentage, 0) as progress_percentage,
                    COALESCE(uc.is_favorite, 0) as is_favorite
                FROM courses c
                LEFT JOIN user_courses uc ON c.id = uc.course_id AND uc.user_id = ?
                WHERE c.id = ?
            ");
            $stmt->execute([$user->id, $id]);
            $course = $stmt->fetch();

            if (!$course) {
                Response::notFound('Curso não encontrado');
            }

            // Get lessons for this course
            $stmt = $this->db->prepare("
                SELECT 
                    l.*,
                    COALESCE(ul.is_completed, 0) as is_completed,
                    COALESCE(ul.is_favorite, 0) as is_favorite,
                    COALESCE(ul.is_liked, 0) as is_liked,
                    COALESCE(ul.last_position_seconds, 0) as last_position_seconds
                FROM lessons l
                LEFT JOIN user_lessons ul ON l.id = ul.lesson_id AND ul.user_id = ?
                WHERE l.course_id = ?
                ORDER BY l.position ASC
            ");
            $stmt->execute([$user->id, $id]);
            $course['lessons'] = $stmt->fetchAll();

            Response::success($course);

        } catch (Exception $e) {
            Response::serverError('Erro ao obter curso: ' . $e->getMessage());
        }
    }

    // GET /api/lessons/:id
    public function getLessonById($id)
    {
        $user = getCurrentUser();

        try {
            $stmt = $this->db->prepare("
                SELECT 
                    l.*,
                    COALESCE(ul.is_completed, 0) as is_completed,
                    COALESCE(ul.is_favorite, 0) as is_favorite,
                    COALESCE(ul.is_liked, 0) as is_liked,
                    COALESCE(ul.last_position_seconds, 0) as last_position_seconds
                FROM lessons l
                LEFT JOIN user_lessons ul ON l.id = ul.lesson_id AND ul.user_id = ?
                WHERE l.id = ?
            ");
            $stmt->execute([$user->id, $id]);
            $lesson = $stmt->fetch();

            if (!$lesson) {
                Response::notFound('Aula não encontrada');
            }

            Response::success($lesson);

        } catch (Exception $e) {
            Response::serverError('Erro ao obter aula: ' . $e->getMessage());
        }
    }

    // POST /api/lessons/:id/favorite
    public function toggleLessonFavorite($id)
    {
        $user = getCurrentUser();

        try {
            // Check if user_lesson record exists
            $stmt = $this->db->prepare("
                SELECT id, is_favorite FROM user_lessons 
                WHERE user_id = ? AND lesson_id = ?
            ");
            $stmt->execute([$user->id, $id]);
            $existing = $stmt->fetch();

            if ($existing) {
                // Update existing record
                $newFavoriteStatus = !$existing['is_favorite'];
                $stmt = $this->db->prepare("
                    UPDATE user_lessons SET is_favorite = ? 
                    WHERE user_id = ? AND lesson_id = ?
                ");
                $stmt->execute([$newFavoriteStatus, $user->id, $id]);

                Response::success(['is_favorite' => (bool) $newFavoriteStatus]);
            } else {
                // Create new record
                $stmt = $this->db->prepare("
                    INSERT INTO user_lessons (user_id, lesson_id, is_favorite) 
                    VALUES (?, ?, 1)
                ");
                $stmt->execute([$user->id, $id]);

                Response::success(['is_favorite' => true]);
            }

        } catch (Exception $e) {
            Response::serverError('Erro ao atualizar favorito: ' . $e->getMessage());
        }
    }

    // POST /api/lessons/:id/like
    public function toggleLessonLike($id)
    {
        $user = getCurrentUser();

        try {
            // Check if user_lesson record exists
            $stmt = $this->db->prepare("
                SELECT id, is_liked FROM user_lessons 
                WHERE user_id = ? AND lesson_id = ?
            ");
            $stmt->execute([$user->id, $id]);
            $existing = $stmt->fetch();

            if ($existing) {
                // Update existing record
                $newLikeStatus = !$existing['is_liked'];
                $stmt = $this->db->prepare("
                    UPDATE user_lessons SET is_liked = ? 
                    WHERE user_id = ? AND lesson_id = ?
                ");
                $stmt->execute([$newLikeStatus, $user->id, $id]);

                Response::success(['is_liked' => (bool) $newLikeStatus]);
            } else {
                // Create new record
                $stmt = $this->db->prepare("
                    INSERT INTO user_lessons (user_id, lesson_id, is_liked) 
                    VALUES (?, ?, 1)
                ");
                $stmt->execute([$user->id, $id]);

                Response::success(['is_liked' => true]);
            }

        } catch (Exception $e) {
            Response::serverError('Erro ao atualizar like: ' . $e->getMessage());
        }
    }

    // POST /api/lessons/:id/complete
    public function markLessonComplete($id)
    {
        $user = getCurrentUser();

        try {
            // Check if user_lesson record exists
            $stmt = $this->db->prepare("
                SELECT id, is_completed FROM user_lessons 
                WHERE user_id = ? AND lesson_id = ?
            ");
            $stmt->execute([$user->id, $id]);
            $existing = $stmt->fetch();

            if ($existing) {
                // Update existing record
                $newCompleteStatus = !$existing['is_completed'];
                $stmt = $this->db->prepare("
                    UPDATE user_lessons SET is_completed = ? 
                    WHERE user_id = ? AND lesson_id = ?
                ");
                $stmt->execute([$newCompleteStatus, $user->id, $id]);

                Response::success(['is_completed' => (bool) $newCompleteStatus]);
            } else {
                // Create new record
                $stmt = $this->db->prepare("
                    INSERT INTO user_lessons (user_id, lesson_id, is_completed) 
                    VALUES (?, ?, 1)
                ");
                $stmt->execute([$user->id, $id]);

                Response::success(['is_completed' => true]);
            }

        } catch (Exception $e) {
            Response::serverError('Erro ao marcar como completa: ' . $e->getMessage());
        }
    }

    // PUT /api/lessons/:id/position
    public function updateVideoPosition($id)
    {
        $user = getCurrentUser();
        $data = json_decode(file_get_contents("php://input"), true);

        $position = $data['position'] ?? null;

        if ($position === null) {
            Response::error('Posição é obrigatória');
        }

        try {
            // Check if user_lesson record exists
            $stmt = $this->db->prepare("
                SELECT id FROM user_lessons 
                WHERE user_id = ? AND lesson_id = ?
            ");
            $stmt->execute([$user->id, $id]);
            $existing = $stmt->fetch();

            if ($existing) {
                // Update existing record
                $stmt = $this->db->prepare("
                    UPDATE user_lessons SET last_position_seconds = ? 
                    WHERE user_id = ? AND lesson_id = ?
                ");
                $stmt->execute([$position, $user->id, $id]);
            } else {
                // Create new record
                $stmt = $this->db->prepare("
                    INSERT INTO user_lessons (user_id, lesson_id, last_position_seconds) 
                    VALUES (?, ?, ?)
                ");
                $stmt->execute([$user->id, $id, $position]);
            }

            Response::success(['last_position_seconds' => (int) $position]);

        } catch (Exception $e) {
            Response::serverError('Erro ao atualizar posição: ' . $e->getMessage());
        }
    }
}
