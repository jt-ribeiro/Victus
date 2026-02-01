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
                    'id' => (int) $user_id,
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

    // POST /api/auth/forgot-password
    public function forgotPassword()
    {
        $data = json_decode(file_get_contents("php://input"), true);
        $email = $data['email'] ?? null;

        if (!$email) {
            Response::error('Email é obrigatório');
        }

        try {
            // Check if user exists
            $stmt = $this->db->prepare("SELECT id, name, email FROM users WHERE email = ?");
            $stmt->execute([$email]);
            $user = $stmt->fetch();

            // Always return success to prevent email enumeration
            if (!$user) {
                Response::success([
                    'message' => 'Se o email existir, receberás instruções em breve'
                ]);
                return;
            }

            // Generate reset token
            $token = bin2hex(random_bytes(32));
            $expiresAt = date('Y-m-d H:i:s', time() + (60 * 60)); // 1 hour

            // Delete any existing tokens for this user
            $stmt = $this->db->prepare("DELETE FROM password_reset_tokens WHERE user_id = ?");
            $stmt->execute([$user['id']]);

            // Insert new token
            $stmt = $this->db->prepare("
                INSERT INTO password_reset_tokens (user_id, token, expires_at) 
                VALUES (?, ?, ?)
            ");
            $stmt->execute([$user['id'], $token, $expiresAt]);

            // Send email with reset link
            require_once __DIR__ . '/../utils/Mailer.php';
            $mailer = new Mailer();

            // Build reset link (update for production front-end URL)
            $resetLink = "http://localhost:3000/#/reset-password?token=" . $token;

            // Send email
            $emailSent = $mailer->sendPasswordReset(
                $user['email'],
                $user['name'],
                $resetLink,
                $token
            );

            // Response (remove dev_token in production)
            $response = [
                'message' => 'Se o email existir, receberás instruções em breve'
            ];

            // In development, include token for testing
            if (getenv('APP_ENV') !== 'production') {
                $response['dev_token'] = $token;
                $response['dev_reset_link'] = $resetLink;
            }

            Response::success($response);

        } catch (Exception $e) {
            Response::serverError('Erro ao processar pedido: ' . $e->getMessage());
        }
    }

    // POST /api/auth/reset-password
    public function resetPassword()
    {
        $data = json_decode(file_get_contents("php://input"), true);
        $token = $data['token'] ?? null;
        $newPassword = $data['password'] ?? null;

        if (!$token || !$newPassword) {
            Response::error('Token e nova password são obrigatórios');
        }

        if (strlen($newPassword) < 6) {
            Response::error('A password deve ter pelo menos 6 caracteres');
        }

        try {
            // Find valid token
            $stmt = $this->db->prepare("
                SELECT user_id, expires_at, used 
                FROM password_reset_tokens 
                WHERE token = ?
            ");
            $stmt->execute([$token]);
            $resetToken = $stmt->fetch();

            if (!$resetToken) {
                Response::error('Token inválido');
            }

            if ($resetToken['used']) {
                Response::error('Este token já foi utilizado');
            }

            if (strtotime($resetToken['expires_at']) < time()) {
                Response::error('Token expirado. Por favor, solicita um novo');
            }

            // Update password
            $password_hash = password_hash($newPassword, PASSWORD_BCRYPT);
            error_log("Resetting password for User ID: " . $resetToken['user_id']);

            $stmt = $this->db->prepare("UPDATE users SET password_hash = ? WHERE id = ?");
            $result = $stmt->execute([$password_hash, $resetToken['user_id']]);
            $rows = $stmt->rowCount();

            error_log("Update User Result: " . ($result ? "Success" : "Fail"));
            error_log("Rows Affected: " . $rows);

            if ($rows === 0) {
                error_log("WARNING: No user rows updated. Check if User ID " . $resetToken['user_id'] . " exists.");
            }

            // Mark token as used
            $stmt = $this->db->prepare("UPDATE password_reset_tokens SET used = 1 WHERE token = ?");
            $stmt->execute([$token]);

            Response::success([
                'message' => 'Password alterada com sucesso! Podes agora fazer login'
            ]);

        } catch (Exception $e) {
            Response::serverError('Erro ao redefinir password: ' . $e->getMessage());
        }
    }
}
