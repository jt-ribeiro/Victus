const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../config/db');

// Generate JWT Token
const generateToken = (user) => {
    return jwt.sign(
        {
            id: user.id,
            email: user.email,
            name: user.name
        },
        process.env.JWT_SECRET,
        { expiresIn: '7d' } // Token expires in 7 days
    );
};

// Login
exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;

        // Validation
        if (!email || !password) {
            return res.status(400).json({
                success: false,
                message: 'Email e password são obrigatórios'
            });
        }

        // Find user by email
        const [users] = await db.query(
            'SELECT * FROM users WHERE email = ?',
            [email]
        );

        if (users.length === 0) {
            return res.status(401).json({
                success: false,
                message: 'Credenciais inválidas'
            });
        }

        const user = users[0];

        // Verify password
        const isPasswordValid = await bcrypt.compare(password, user.password_hash);

        if (!isPasswordValid) {
            return res.status(401).json({
                success: false,
                message: 'Credenciais inválidas'
            });
        }

        // Generate token
        const token = generateToken(user);

        // Return user data and token
        res.json({
            success: true,
            message: 'Login efetuado com sucesso',
            data: {
                user: {
                    id: user.id,
                    name: user.name,
                    email: user.email,
                    avatar_url: user.avatar_url
                },
                token
            }
        });

    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({
            success: false,
            message: 'Erro ao efetuar login'
        });
    }
};

// Register
exports.register = async (req, res) => {
    try {
        const { name, email, password } = req.body;

        // Validation
        if (!name || !email || !password) {
            return res.status(400).json({
                success: false,
                message: 'Nome, email e password são obrigatórios'
            });
        }

        if (password.length < 6) {
            return res.status(400).json({
                success: false,
                message: 'A password deve ter pelo menos 6 caracteres'
            });
        }

        // Check if user already exists
        const [existingUsers] = await db.query(
            'SELECT id FROM users WHERE email = ?',
            [email]
        );

        if (existingUsers.length > 0) {
            return res.status(409).json({
                success: false,
                message: 'Este email já está registado'
            });
        }

        // Hash password
        const password_hash = await bcrypt.hash(password, 10);

        // Create user
        const [result] = await db.query(
            'INSERT INTO users (name, email, password_hash) VALUES (?, ?, ?)',
            [name, email, password_hash]
        );

        const userId = result.insertId;

        // Get created user
        const [newUsers] = await db.query(
            'SELECT id, name, email, avatar_url FROM users WHERE id = ?',
            [userId]
        );

        const newUser = newUsers[0];

        // Generate token
        const token = generateToken(newUser);

        res.status(201).json({
            success: true,
            message: 'Conta criada com sucesso',
            data: {
                user: newUser,
                token
            }
        });

    } catch (error) {
        console.error('Register error:', error);
        res.status(500).json({
            success: false,
            message: 'Erro ao criar conta'
        });
    }
};

// Get current user profile
exports.getProfile = async (req, res) => {
    try {
        const userId = req.user.id;

        const [users] = await db.query(
            'SELECT id, name, email, avatar_url, created_at FROM users WHERE id = ?',
            [userId]
        );

        if (users.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Utilizador não encontrado'
            });
        }

        res.json({
            success: true,
            data: users[0]
        });

    } catch (error) {
        console.error('Get profile error:', error);
        res.status(500).json({
            success: false,
            message: 'Erro ao obter perfil'
        });
    }
};
