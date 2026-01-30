<?php
require_once __DIR__ . '/../utils/JWT.php';
require_once __DIR__ . '/../utils/Response.php';

// Authentication middleware
function requireAuth()
{
    $headers = getallheaders();
    $auth_header = $headers['Authorization'] ?? $headers['authorization'] ?? null;

    if (!$auth_header) {
        Response::unauthorized('Token não fornecido');
    }

    // Extract token from "Bearer <token>"
    $token = null;
    if (preg_match('/Bearer\s+(.*)$/i', $auth_header, $matches)) {
        $token = $matches[1];
    }

    if (!$token) {
        Response::unauthorized('Formato de token inválido');
    }

    // Decode and validate token
    $decoded = JWT::decode($token);
    if (!$decoded) {
        Response::unauthorized('Token inválido ou expirado');
    }

    // Add user data to global scope
    global $current_user;
    $current_user = (object) $decoded;

    return $current_user;
}

// Get current authenticated user
function getCurrentUser()
{
    global $current_user;
    return $current_user ?? null;
}
