<?php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../utils/Response.php';

class DashboardController
{
    private $db;

    public function __construct()
    {
        $database = new Database();
        $this->db = $database->getConnection();
    }

    // GET /api/dashboard
    public function getDashboard()
    {
        $user = getCurrentUser();

        try {
            // Get user name
            $stmt = $this->db->prepare("SELECT name FROM users WHERE id = ?");
            $stmt->execute([$user->id]);
            $userData = $stmt->fetch();

            // Get user progress
            $stmt = $this->db->prepare("
                SELECT current_value, target_value, unit
                FROM user_progress
                WHERE user_id = ?
                LIMIT 1
            ");
            $stmt->execute([$user->id]);
            $progress = $stmt->fetch();

            if (!$progress) {
                $progress = [
                    'current_value' => 0,
                    'target_value' => 0,
                    'unit' => 'kg',
                    'percentage' => 0
                ];
            } else {
                $progress['percentage'] = $progress['target_value'] > 0
                    ? ($progress['current_value'] / $progress['target_value']) * 100
                    : 0;
            }

            Response::success([
                'user_name' => $userData['name'] ?? 'Utilizador',
                'progress' => $progress
            ]);

        } catch (Exception $e) {
            Response::serverError('Erro ao obter dashboard: ' . $e->getMessage());
        }
    }

    // GET /api/events
    public function getEvents()
    {
        $user = getCurrentUser();

        try {
            $stmt = $this->db->prepare("
                SELECT id, title, description, event_date as date, event_type as type
                FROM events
                WHERE is_active = 1
                ORDER BY event_date ASC
                LIMIT 10
            ");
            $stmt->execute();
            $events = $stmt->fetchAll();

            Response::success($events);

        } catch (Exception $e) {
            Response::serverError('Erro ao obter eventos: ' . $e->getMessage());
        }
    }
}
