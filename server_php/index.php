<?php
// Error reporting for development
error_reporting(E_ALL);
ini_set('display_errors', 0); // Disable output to screen to prevent JSON corruption

// Start session if needed
// session_start();

// Load environment variables
require_once __DIR__ . '/utils/EnvLoader.php';
EnvLoader::load(__DIR__ . '/.env');

// Load CORS configuration
require_once __DIR__ . '/config/cors.php';

// Load router
require_once __DIR__ . '/routes/api.php';
