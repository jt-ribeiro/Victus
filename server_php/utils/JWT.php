<?php
// JWT Helper Class
class JWT
{
    private static $secret_key;

    public static function init()
    {
        self::$secret_key = getenv('JWT_SECRET') ?: 'your-secret-key-change-in-production';
    }

    public static function encode($payload)
    {
        self::init();

        $header = self::base64UrlEncode(json_encode(['typ' => 'JWT', 'alg' => 'HS256']));
        $payload = self::base64UrlEncode(json_encode($payload));
        $signature = self::base64UrlEncode(hash_hmac('sha256', "$header.$payload", self::$secret_key, true));

        return "$header.$payload.$signature";
    }

    public static function decode($jwt)
    {
        self::init();

        $parts = explode('.', $jwt);
        if (count($parts) !== 3) {
            return null;
        }

        list($header, $payload, $signature) = $parts;

        // Verify signature
        $valid_signature = self::base64UrlEncode(
            hash_hmac('sha256', "$header.$payload", self::$secret_key, true)
        );

        if ($signature !== $valid_signature) {
            return null;
        }

        $payload_data = json_decode(self::base64UrlDecode($payload), true);

        // Check expiration
        if (isset($payload_data['exp']) && $payload_data['exp'] < time()) {
            return null;
        }

        return $payload_data;
    }

    private static function base64UrlEncode($data)
    {
        return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
    }

    private static function base64UrlDecode($data)
    {
        return base64_decode(strtr($data, '-_', '+/'));
    }
}
