<?php
// Error reporting for development
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Start session if needed
// session_start();

// Load CORS configuration
require_once __DIR__ . '/config/cors.php';

// Load router
require_once __DIR__ . '/routes/api.php';
