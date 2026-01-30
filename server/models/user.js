const db = require('../config/db');

// TODO: Implement User model methods
class User {
    static async findByEmail(email) {
        // Placeholder for finding user by email
        const [rows] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
        return rows[0];
    }

    static async create(userData) {
        // Placeholder for creating user
        const { name, email, password_hash } = userData;
        const [result] = await db.query(
            'INSERT INTO users (name, email, password_hash) VALUES (?, ?, ?)',
            [name, email, password_hash]
        );
        return result.insertId;
    }
}

module.exports = User;
