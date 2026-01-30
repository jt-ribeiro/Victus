const db = require('../config/db');

// Get dashboard data for a user
exports.getDashboard = async (req, res) => {
    try {
        const userId = req.user.id;

        // Get user info
        const [users] = await db.query(
            'SELECT id, name, email, avatar_url FROM users WHERE id = ?',
            [userId]
        );

        if (users.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Utilizador não encontrado'
            });
        }

        const user = users[0];

        // Get user progress (weight)
        const [progress] = await db.query(
            `SELECT metric_type, metric_name, current_value, target_value, unit, progress_percentage 
       FROM user_progress 
       WHERE user_id = ? AND metric_type = 'weight'
       LIMIT 1`,
            [userId]
        );

        // Get upcoming events
        const [events] = await db.query(
            `SELECT id, title, event_date, event_type 
       FROM events 
       WHERE is_active = TRUE AND event_date >= CURDATE()
       ORDER BY event_date ASC 
       LIMIT 3`,
            []
        );

        // Get user's active courses count
        const [coursesCount] = await db.query(
            'SELECT COUNT(*) as total FROM user_courses WHERE user_id = ?',
            [userId]
        );

        res.json({
            success: true,
            data: {
                user: {
                    name: user.name,
                    email: user.email,
                    avatar_url: user.avatar_url
                },
                progress: progress.length > 0 ? {
                    current_value: progress[0].current_value,
                    target_value: progress[0].target_value,
                    unit: progress[0].unit,
                    percentage: progress[0].progress_percentage
                } : null,
                events: events.map(event => ({
                    id: event.id,
                    title: event.title,
                    date: event.event_date,
                    type: event.event_type
                })),
                stats: {
                    active_courses: coursesCount[0].total
                }
            }
        });

    } catch (error) {
        console.error('Get dashboard error:', error);
        res.status(500).json({
            success: false,
            message: 'Erro ao carregar dashboard'
        });
    }
};

// Get all events
exports.getEvents = async (req, res) => {
    try {
        const [events] = await db.query(
            `SELECT id, title, description, event_date, event_type 
       FROM events 
       WHERE is_active = TRUE
       ORDER BY event_date ASC`,
            []
        );

        res.json({
            success: true,
            data: events
        });

    } catch (error) {
        console.error('Get events error:', error);
        res.status(500).json({
            success: false,
            message: 'Erro ao carregar eventos'
        });
    }
};
