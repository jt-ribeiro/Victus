<?php
// Response helper class
class Response
{
    public static function success($data = null, $message = null, $code = 200)
    {
        http_response_code($code);
        echo json_encode([
            'success' => true,
            'data' => $data,
            'message' => $message
        ], JSON_UNESCAPED_UNICODE);
        exit();
    }

    public static function error($message, $code = 400)
    {
        http_response_code($code);
        echo json_encode([
            'success' => false,
            'message' => $message
        ], JSON_UNESCAPED_UNICODE);
        exit();
    }

    public static function unauthorized($message = 'Não autorizado')
    {
        self::error($message, 401);
    }

    public static function notFound($message = 'Recurso não encontrado')
    {
        self::error($message, 404);
    }

    public static function serverError($message = 'Erro interno do servidor')
    {
        self::error($message, 500);
    }
}
