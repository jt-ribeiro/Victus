<?php

class Mailer
{
    private $smtp_host;
    private $smtp_port;
    private $smtp_user;
    private $smtp_pass;
    private $apiKey;
    private $from_email;
    private $from_name;

    public function __construct()
    {
        // Try to load env again just in case it wasn't loaded in the entry point (though it should be)
        if (!getenv('RESEND_API_KEY')) {
            if (file_exists(__DIR__ . '/../utils/EnvLoader.php')) {
                require_once __DIR__ . '/../utils/EnvLoader.php';
                EnvLoader::load(__DIR__ . '/../.env');
            }
        }

        $this->apiKey = getenv('RESEND_API_KEY') ?: '';
        $this->from_email = getenv('MAIL_FROM') ?: 'onboarding@resend.dev';
        $this->from_name = getenv('MAIL_FROM_NAME') ?: 'Video Streaming App';
    }

    public function sendPasswordReset($toEmail, $toName, $resetLink, $token)
    {
        $subject = 'Recuperação de Password - Video Streaming';
        $htmlBody = $this->getPasswordResetTemplate($toName, $resetLink, $token);

        // Always log for development visibility
        if (getenv('APP_ENV') !== 'production') {
            error_log("========== PASSWORD RESET LINK (DEV) ==========");
            error_log("To: {$toEmail}");
            error_log("Link: {$resetLink}");
            error_log("Token: {$token}");
            error_log("=============================================");
        }

        if (empty($this->apiKey)) {
            // In dev, return true to allow flow to continue even without email
            return (getenv('APP_ENV') !== 'production');
        }

        return $this->sendViaResend($toEmail, $toName, $subject, $htmlBody);
    }

    private function sendViaResend($to, $toName, $subject, $htmlBody)
    {
        $url = 'https://api.resend.com/emails';

        $data = [
            'from' => "{$this->from_name} <{$this->from_email}>",
            'to' => [$to],
            'subject' => $subject,
            'html' => $htmlBody
        ];

        $ch = curl_init($url);

        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Authorization: Bearer ' . $this->apiKey,
            'Content-Type: application/json'
        ]);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        // Important for some local dev environments
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $error = curl_error($ch);

        curl_close($ch);

        if ($error) {
            error_log("Resend API cURL Error: " . $error);
            return false;
        }

        if ($httpCode >= 200 && $httpCode < 300) {
            // Success
            return true;
        } else {
            // API returned an error
            error_log("Resend API Error Body: " . $response);
            return false;
        }
    }

    private function sendViaSocket($to, $toName, $subject, $body)
    {
        try {
            $host = $this->smtp_host;
            $port = $this->smtp_port;

            // Establish connection
            $protocol = ($port == 465) ? 'ssl' : 'tcp';
            $socket = @stream_socket_client("$protocol://$host:$port", $errno, $errstr, 10);

            if (!$socket) {
                error_log("SMTP Connect Failed: $errstr ($errno)");
                return false;
            }

            $this->readResponse($socket); // Initial banner

            // Handshake
            $this->sendCommand($socket, "EHLO " . gethostname());

            // STARTTLS for port 587
            if ($port == 587) {
                $this->sendCommand($socket, "STARTTLS");
                if (!stream_socket_enable_crypto($socket, true, STREAM_CRYPTO_METHOD_TLS_CLIENT)) {
                    error_log("SMTP TLS Handshake Failed");
                    fclose($socket);
                    return false;
                }
                $this->sendCommand($socket, "EHLO " . gethostname());
            }

            // Auth
            $this->sendCommand($socket, "AUTH LOGIN");
            $this->sendCommand($socket, base64_encode($this->smtp_user));
            $this->sendCommand($socket, base64_encode($this->smtp_pass));

            // Mail
            $this->sendCommand($socket, "MAIL FROM: <{$this->from_email}>");
            $this->sendCommand($socket, "RCPT TO: <{$to}>");
            $this->sendCommand($socket, "DATA");

            // Headers & Body
            $headers = "MIME-Version: 1.0\r\n";
            $headers .= "Content-Type: text/html; charset=UTF-8\r\n";
            $headers .= "From: {$this->from_name} <{$this->from_email}>\r\n";
            $headers .= "To: {$toName} <{$to}>\r\n";
            $headers .= "Subject: {$subject}\r\n";
            $headers .= "\r\n";

            $this->sendCommand($socket, $headers . $body . "\r\n.");
            $this->sendCommand($socket, "QUIT");

            fclose($socket);
            return true;

        } catch (Exception $e) {
            error_log("SMTP Error: " . $e->getMessage());
            return false;
        }
    }

    private function sendCommand($socket, $command)
    {
        fwrite($socket, $command . "\r\n");
        $response = $this->readResponse($socket);

        // Basic error checking (4xx and 5xx are errors)
        if (substr($response, 0, 1) == '4' || substr($response, 0, 1) == '5') {
            throw new Exception("SMTP Command Failed: $command -> $response");
        }
        return $response;
    }

    private function readResponse($socket)
    {
        $response = '';
        while (($line = fgets($socket, 515)) !== false) {
            $response .= $line;
            if (substr($line, 3, 1) == ' ')
                break;
        }
        return $response;
    }

    private function fallbackHandler($toEmail, $toName, $subject)
    {
        // On Windows without SMTP locally configured, mail() usually fails.
        // We log the attempt and if we are in DEV mode, we return true.
        error_log("========== EMAIL NOT SENT (Using fallback) ==========");
        error_log("Sending to: $toEmail");
        error_log("Check your .env SMTP configuration if you want real emails.");

        // In dev, we pretend it worked so the UI shows success
        if (getenv('APP_ENV') !== 'production' || empty(getenv('APP_ENV'))) {
            return true;
        }
        return false;
    }

    private function getPasswordResetTemplate($name, $resetLink, $token)
    {
        return "
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset='UTF-8'>
            <style>
                body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; background-color: #f4f4f4; }
                .container { max-width: 600px; margin: 20px auto; background: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
                .header { background: #D4989E; color: white; padding: 40px 20px; text-align: center; }
                .content { padding: 40px 30px; }
                .button { display: inline-block; padding: 14px 30px; background: #D4989E; color: white !important; text-decoration: none; border-radius: 50px; margin: 25px 0; font-weight: 600; font-size: 16px; transition: background 0.3s; }
                .button:hover { background: #c07a81; }
                .token-box { background: #f8f9fa; padding: 20px; border: 2px dashed #D4989E; border-radius: 8px; font-family: 'Courier New', monospace; word-break: break-all; margin: 25px 0; font-size: 18px; text-align: center; color: #333; letter-spacing: 2px; font-weight: bold; }
                .footer { background: #f8f9fa; text-align: center; color: #888; font-size: 13px; padding: 20px; border-top: 1px solid #eee; }
                h1 { margin: 0; font-size: 28px; font-weight: 600; }
                p { margin: 15px 0; color: #555; }
                .note { background: #fff8e1; border-left: 4px solid #ffc107; padding: 15px; border-radius: 4px; font-size: 14px; color: #856404; margin-top: 20px; }
            </style>
        </head>
        <body>
            <div class='container'>
                <div class='header'>
                    <h1>Recuperar Palavra-passe</h1>
                </div>
                <div class='content'>
                    <p>Olá <strong>{$name}</strong>,</p>
                    
                    <p>Recebemos um pedido para redefinir a palavra-passe da tua conta na <strong>Victus</strong>.</p>
                    
                    <p>Usa o código abaixo na aplicação:</p>
                    
                    <div class='token-box'>
                        {$token}
                    </div>
                    
                    <p>Ou clica no botão se estiveres no telemóvel:</p>
                    
                    <div style='text-align: center;'>
                        <a href='{$resetLink}' class='button'>Redefinir Agora</a>
                    </div>
                    
                    <div class='note'>
                        ⏰ <strong>Nota:</strong> Este código expira em 1 hora.
                    </div>
                    
                    <p style='font-size: 13px; margin-top: 30px;'>Se não pediste para alterar a palavra-passe, podes ignorar este email com segurança.</p>
                </div>
                <div class='footer'>
                    <p>&copy; " . date('Y') . " Victus App. Todos os direitos reservados.</p>
                </div>
            </div>
        </body>
        </html>
        ";
    }
}
