# PHP Video Streaming API

API REST em PHP puro (sem frameworks) para aplicação de streaming de vídeo.

## Requisitos

- PHP >= 7.4
- MySQL >= 5.7
- Apache com mod_rewrite habilitado
- XAMPP (recomendado para desenvolvimento)

## Estrutura do Projeto

```
server_php/
├── config/          # Configurações (database, CORS)
├── controllers/     # Lógica de negócio
├── middleware/      # Autenticação JWT
├── routes/          # Definição de rotas
├── utils/           # Helpers (JWT, Response)
├── .htaccess        # Rewrite rules Apache
├── index.php        # Entry point
└── .env             # Variáveis de ambiente
```

## Instalação

### 1. Copiar .env

```bash
copy .env.example .env
```

Edite `.env` com suas credenciais MySQL.

### 2. Configurar Apache (XAMPP)

Adicione no `httpd.conf` ou crie um virtual host:

```apache
<VirtualHost *:3000>
    DocumentRoot "D:/Projetos/video-streaming-app/server_php"
    ServerName localhost
    
    <Directory "D:/Projetos/video-streaming-app/server_php">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

Reinicie o Apache.

### 3. Importar Base de Dados

```sql
mysql -u root -p < ../server/db/schema_complete.sql
```

## Endpoints da API

### Autenticação

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| POST | `/api/auth/login` | Login |
| POST | `/api/auth/register` | Registo |
| GET | `/api/auth/profile` | Perfil (requer auth) |

### Dashboard

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/dashboard` | Dashboard (requer auth) |
| GET | `/api/events` | Eventos (requer auth) |

### Cursos e Aulas

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/courses` | Lista de cursos (requer auth) |
| GET | `/api/courses/:id` | Detalhes do curso (requer auth) |
| GET | `/api/lessons/:id` | Detalhes da aula (requer auth) |
| POST | `/api/lessons/:id/favorite` | Toggle favorito (requer auth) |
| POST | `/api/lessons/:id/like` | Toggle like (requer auth) |
| POST | `/api/lessons/:id/complete` | Toggle completar (requer auth) |
| PUT | `/api/lessons/:id/position` | Atualizar posição (requer auth) |

## Usar com Flutter

No `api_service.dart`, muda a `baseUrl`:

```dart
static const String baseUrl = 'http://localhost:3000/api';
```

## Testes

Podes usar o Postman ou CURL:

```bash
# Login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123"}'
```

## Tecnologias

- PHP puro (sem frameworks)
- PDO para MySQL
- JWT para autenticação
- Apache mod_rewrite para routing
