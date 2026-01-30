<?php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../utils/JWT.php';
require_once __DIR__ . '/../utils/Response.php';

class AuthController
{
    private $db;

    public function __construct()
    {
        $database = new Database();
        $this->db = $database->getConnection();
    }

    // POST /api/auth/login
    public function login()
    {
        $data = json_decode(file_get_contents("php://input"), true);

        $email = $data['email'] ?? null;
        $password = $data['password'] ?? null;

        if (!$email || !$password) {
            Response::error('Email e password são obrigatórios');
        }

        try {
            $stmt = $this->db->prepare("SELECT * FROM users WHERE email = ?");
            $stmt->execute([$email]);
            $user = $stmt->fetch();

            if (!$user || !password_verify($password, $user['password_hash'])) {
                Response::unauthorized('Credenciais inválidas');
            }

            // Generate JWT token
            $payload = [
                'id' => $user['id'],
                'email' => $user['email'],
                'name' => $user['name'],
                'exp' => time() + (7 * 24 * 60 * 60) // 7 days
            ];

            $token = JWT::encode($payload);

            Response::success([
                'user' => [
                    'id' => $user['id'],
                    'name' => $user['name'],
                    'email' => $user['email'],
                    'avatar_url' => $user['avatar_url']
                ],
                'token' => $token
            ], 'Login realizado com sucesso');

        } catch (Exception $e) {
            Response::serverError('Erro ao fazer login: ' . $e->getMessage());
        }
    }

    // POST /api/auth/register
    public function register()
    {
        $data = json_decode(file_get_contents("php://input"), true);

        $name = $data['name'] ?? null;
        $email = $data['email'] ?? null;
        $password = $data['password'] ?? null;

        if (!$name || !$email || !$password) {
            Response::error('Nome, email e password são obrigatórios');
        }

        try {
            // Check if email already exists
            $stmt = $this->db->prepare("SELECT id FROM users WHERE email = ?");
            $stmt->execute([$email]);
            if ($stmt->fetch()) {
                Response::error('Email já está em uso');
            }

            // Hash password
            $password_hash = password_hash($password, PASSWORD_BCRYPT);

            // Insert user
            $stmt = $this->db->prepare("
                INSERT INTO users (name, email, password_hash) 
                VALUES (?, ?, ?)
            ");
            $stmt->execute([$name, $email, $password_hash]);

            $user_id = $this->db->lastInsertId();

            // Generate JWT token
            $payload = [
                'id' => $user_id,
                'email' => $email,
                'name' => $name,
                'exp' => time() + (7 * 24 * 60 * 60)
            ];

            $token = JWT::encode($payload);

            Response::success([
                'user' => [
                    'id' => $user_id,
                    'name' => $name,
                    'email' => $email,
                    'avatar_url' => null
                ],
                'token' => $token
            ], 'Conta criada com sucesso', 201);

        } catch (Exception $e) {
            Response::serverError('Erro ao criar conta: ' . $e->getMessage());
        }
    }

    // GET /api/auth/profile (requires auth)
    public function getProfile()
    {
        $user = getCurrentUser();

        try {
            $stmt = $this->db->prepare("SELECT id, name, email, avatar_url FROM users WHERE id = ?");
            $stmt->execute([$user->id]);
            $userData = $stmt->fetch();

            if (!$userData) {
                Response::notFound('Utilizador não encontrado');
            }

            Response::success($userData);

        } catch (Exception $e) {
            Response::serverError('Erro ao obter perfil: ' . $e->getMessage());
        }
    }
}
