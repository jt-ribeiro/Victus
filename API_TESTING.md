# 🚀 Victus API - Guia de Testes

## 📋 Pré-requisitos

1. **Importar Base de Dados**
```bash
# No phpMyAdmin ou MySQL CLI:
source d:/Projetos/video-streaming-app/server/db/schema_complete.sql
```

2. **Iniciar Servidor**
```bash
cd server
node index.js
```

Servidor: http://localhost:3000

---

## 🔐 Autenticação

### 1. Login
```http
POST http://localhost:3000/api/auth/login
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "test123"
}
```

**Resposta:**
```json
{
  "success": true,
  "message": "Login efetuado com sucesso",
  "data": {
    "user": {
      "id": 1,
      "name": "Cristiana",
      "email": "test@example.com"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

### 2. Registar Nova Conta
```http
POST http://localhost:3000/api/auth/register
Content-Type: application/json

{
  "name": "Maria Silva",
  "email": "maria@example.com",
  "password": "senha123"
}
```

### 3. Ver Perfil (Requer Token)
```http
GET http://localhost:3000/api/auth/profile
Authorization: Bearer SEU_TOKEN_AQUI
```

---

## 🏠 Dashboard

### Obter Dados do Dashboard
```http
GET http://localhost:3000/api/dashboard
Authorization: Bearer SEU_TOKEN_AQUI
```

**Resposta:**
```json
{
  "success": true,
  "data": {
    "user": {
      "name": "Cristiana",
      "email": "test@example.com"
    },
    "progress": {
      "current_value": 2.00,
      "target_value": 10.00,
      "unit": "kg",
      "percentage": 20.00
    },
    "events": [
      {
        "id": 1,
        "title": "Masterclass de Nutrição",
        "date": "2026-05-23",
        "type": "masterclass"
      }
    ]
  }
}
```

### Obter Todos os Eventos
```http
GET http://localhost:3000/api/events
Authorization: Bearer SEU_TOKEN_AQUI
```

---

## 📚 Biblioteca / Cursos

### 1. Listar Todos os Cursos
```http
GET http://localhost:3000/api/courses
Authorization: Bearer SEU_TOKEN_AQUI
```

**Resposta:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "Liberdade Alimentar",
      "description": "Aprende a ter uma relação saudável...",
      "thumbnail_color": "#8B2635",
      "status": "active",
      "progress_percentage": 80.00,
      "is_favorite": true
    }
  ]
}
```

### 2. Detalhes de um Curso (com Aulas)
```http
GET http://localhost:3000/api/courses/1
Authorization: Bearer SEU_TOKEN_AQUI
```

**Resposta:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "Liberdade Alimentar",
    "progress_percentage": 80.00,
    "lessons": [
      {
        "id": 1,
        "title": "Boas-vindas",
        "video_url": "http://...",
        "duration_seconds": 180,
        "is_completed": true,
        "is_favorite": false,
        "is_liked": true,
        "last_position_seconds": 0
      }
    ]
  }
}
```

---

## 🎬 Player / Aulas

### 1. Detalhes de uma Aula
```http
GET http://localhost:3000/api/lessons/1
Authorization: Bearer SEU_TOKEN_AQUI
```

### 2. Marcar como Favorita
```http
POST http://localhost:3000/api/lessons/1/favorite
Authorization: Bearer SEU_TOKEN_AQUI
```

### 3. Dar Like
```http
POST http://localhost:3000/api/lessons/1/like
Authorization: Bearer SEU_TOKEN_AQUI
```

### 4. Marcar como Completa
```http
POST http://localhost:3000/api/lessons/1/complete
Authorization: Bearer SEU_TOKEN_AQUI
```

### 5. Atualizar Posição do Vídeo
```http
PUT http://localhost:3000/api/lessons/1/position
Authorization: Bearer SEU_TOKEN_AQUI
Content-Type: application/json

{
  "position_seconds": 120
}
```

---

## 📊 Estrutura de Resposta

Todas as respostas seguem este formato:

### Sucesso
```json
{
  "success": true,
  "data": { ... },
  "message": "Mensagem opcional"
}
```

### Erro
```json
{
  "success": false,
  "message": "Descrição do erro"
}
```

---

## 🔑 Credenciais de Teste

```
Email: test@example.com
Password: test123
```

---

## 🧪 Testar com cURL

### Login
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123"}'
```

### Dashboard (substitui TOKEN)
```bash
curl http://localhost:3000/api/dashboard \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"
```

---

## ✅ Checklist de Testes

- [ ] Login com credenciais corretas
- [ ] Login com credenciais erradas (deve falhar)
- [ ] Registar nova conta
- [ ] Ver perfil (com token)
- [ ] Dashboard com dados do user
- [ ] Listar cursos
- [ ] Ver detalhes de curso
- [ ] Marcar aula como favorita
- [ ] Dar like em aula
- [ ] Marcar aula como completa
- [ ] Atualizar posição do vídeo

---

## 🐛 Debugging

Se tiveres erros:

1. **Erro de conexão BD**: Verifica `.env` e XAMPP MySQL
2. **Token inválido**: Faz login novamente
3. **404**: Verifica se o servidor está a correr
4. **500**: Verifica logs do servidor no terminal

---

**Próximo Passo**: Integrar estes endpoints no Flutter! 🎯
