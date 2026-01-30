<?php
require_once __DIR__ . '/../middleware/auth.php';
require_once __DIR__ . '/../controllers/AuthController.php';
require_once __DIR__ . '/../controllers/DashboardController.php';
require_once __DIR__ . '/../controllers/CourseController.php';

class Router
{
    private $routes = [];
    private $method;
    private $path;

    public function __construct()
    {
        $this->method = $_SERVER['REQUEST_METHOD'];
        $this->path = $this->getPath();
    }

    private function getPath()
    {
        $uri = $_SERVER['REQUEST_URI'];
        // Remove query string
        if (($pos = strpos($uri, '?')) !== false) {
            $uri = substr($uri, 0, $pos);
        }
        // Remove /index.php if present
        $uri = str_replace('/index.php', '', $uri);
        return rtrim($uri, '/');
    }

    public function get($path, $handler, $middleware = null)
    {
        $this->addRoute('GET', $path, $handler, $middleware);
    }

    public function post($path, $handler, $middleware = null)
    {
        $this->addRoute('POST', $path, $handler, $middleware);
    }

    public function put($path, $handler, $middleware = null)
    {
        $this->addRoute('PUT', $path, $handler, $middleware);
    }

    public function delete($path, $handler, $middleware = null)
    {
        $this->addRoute('DELETE', $path, $handler, $middleware);
    }

    private function addRoute($method, $path, $handler, $middleware)
    {
        $this->routes[] = [
            'method' => $method,
            'path' => $path,
            'handler' => $handler,
            'middleware' => $middleware
        ];
    }

    public function run()
    {
        foreach ($this->routes as $route) {
            if ($this->matchRoute($route)) {
                return;
            }
        }

        // No route matched
        http_response_code(404);
        echo json_encode([
            'success' => false,
            'message' => 'Rota não encontrada'
        ]);
    }

    private function matchRoute($route)
    {
        if ($route['method'] !== $this->method) {
            return false;
        }

        // Convert route path pattern to regex
        $pattern = preg_replace('/:\w+/', '([^/]+)', $route['path']);
        $pattern = '#^' . $pattern . '$#';

        if (preg_match($pattern, $this->path, $matches)) {
            // Extract params
            array_shift($matches); // Remove full match

            // Run middleware if exists
            if ($route['middleware']) {
                call_user_func($route['middleware']);
            }

            // Run handler with params
            call_user_func($route['handler'], ...$matches);
            return true;
        }

        return false;
    }
}

// Initialize router
$router = new Router();

// ====================================
// PUBLIC ROUTES (No authentication)
// ====================================

// Auth routes
$router->post('/api/auth/login', function () {
    $controller = new AuthController();
    $controller->login();
});

$router->post('/api/auth/register', function () {
    $controller = new AuthController();
    $controller->register();
});

// ====================================
// PROTECTED ROUTES (Require auth)
// ====================================

// User profile
$router->get('/api/auth/profile', function () {
    $controller = new AuthController();
    $controller->getProfile();
}, 'requireAuth');

// Dashboard
$router->get('/api/dashboard', function () {
    $controller = new DashboardController();
    $controller->getDashboard();
}, 'requireAuth');

$router->get('/api/events', function () {
    $controller = new DashboardController();
    $controller->getEvents();
}, 'requireAuth');

// Courses & Library
$router->get('/api/courses', function () {
    $controller = new CourseController();
    $controller->getAllCourses();
}, 'requireAuth');

$router->get('/api/courses/:id', function ($id) {
    $controller = new CourseController();
    $controller->getCourseById($id);
}, 'requireAuth');

// Lessons
$router->get('/api/lessons/:id', function ($id) {
    $controller = new CourseController();
    $controller->getLessonById($id);
}, 'requireAuth');

$router->post('/api/lessons/:id/favorite', function ($id) {
    $controller = new CourseController();
    $controller->toggleLessonFavorite($id);
}, 'requireAuth');

$router->post('/api/lessons/:id/like', function ($id) {
    $controller = new CourseController();
    $controller->toggleLessonLike($id);
}, 'requireAuth');

$router->post('/api/lessons/:id/complete', function ($id) {
    $controller = new CourseController();
    $controller->markLessonComplete($id);
}, 'requireAuth');

$router->put('/api/lessons/:id/position', function ($id) {
    $controller = new CourseController();
    $controller->updateVideoPosition($id);
}, 'requireAuth');

// Run the router
$router->run();
