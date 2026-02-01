# Video Streaming App - Victus

Uma aplicação completa de streaming de vídeo construída com **Flutter** (frontend) e **PHP Nativo** (backend), focada em performance e simplicidade.

## 🎯 Funcionalidades Principais

- **Autenticação Completa:** Login, Registo e **Recuperação de Password com Código** (via Email).
- **Dashboard Interativa:** Visualização do progresso (kg perdidos) e próximos eventos.
- **Streaming de Vídeo:** Player integrado com suporte a lista de reprodução.
- **Biblioteca:** Filtros por categoria e gestão de favoritos.
- **Design Moderno:** Tema "Victus" com paleta de cores harmoniosa (Rosa/Branco) e UX fluida.
- **Recuperação de Conta:** Sistema robusto usando a **Resend API** para envio instantâneo de códigos.

## 📁 Estrutura do Projeto

```
video-streaming-app/
├── server_php/             # Backend (PHP Puro)
│   ├── config/            # Ligação à Base de Dados
│   ├── controllers/       # Lógica de Autenticação e Dados
│   ├── db/                # Scripts SQL (Tabelas: users, tokens, videos)
│   ├── utils/             # Helpers (Mailer, JWT, Resposta JSON)
│   ├── .env               # Variáveis de Ambiente (DB, Resend API)
│   └── index.php          # Ponto de Entrada (Router)
│
└── app/                    # Frontend (Flutter)
    ├── lib/
    │   ├── providers/     # Gestão de Estado (Provider)
    │   ├── screens/       # Ecrãs (Login, Dashboard, Player)
    │   ├── services/      # Comunicação com API
    │   └── widgets/       # Componentes Reutilizáveis
    └── pubspec.yaml       # Dependências
```

## 🚀 Como Começar

### Pré-requisitos
- **XAMPP** (ou qualquer servidor PHP + MySQL)
- **Flutter SDK**
- Conta na **Resend.com** (para emails)

### 1. Configuração do Backend (PHP)

1. **Base de Dados:**
   - Cria uma base de dados no MySQL chamada `video_streaming_db`.
   - Importa os scripts da pasta `server_php/db/`.

2. **Variáveis de Ambiente:**
   - Vai à pasta `server_php`.
   - Copia `.env.example` para `.env`.
   - Configura o acesso à BD e a tua chave da Resend API (`RESEND_API_KEY`).

3. **Iniciar Servidor:**
   ```bash
   cd server_php
   php -S localhost:3000
   ```

### 2. Configuração do Frontend (Flutter)

1. Instala as dependências:
   ```bash
   cd app
   flutter pub get
   ```

2. Verifica o endereço da API:
   - No ficheiro `lib/services/api_service.dart`, certifica-te que o IP/Porta corresponde ao teu servidor local.

3. Executa a App:
   ```bash
   flutter run
   ```

## � Sistema de Recuperação de Password

Este projeto abandonou o uso de SMTP instável (Gmail/Outlook) em favor da **Resend API**.
- **Envio Rápido:** Emails entregues em milissegundos.
- **Fluxo na App:**
  1. Utilizador pede recuperação.
  2. Recebe código de 64 chars por email.
  3. Insere o código na App (botão "Já tenho um código").
  4. Define nova password.

*Para configurar, vê o ficheiro `server_php/EMAIL_SETUP.md`.*

## 🔧 Tecnologias Usadas

**Backend:**
- PHP 7.4+ (Sem frameworks pesadas)
- PDO (MySQL)
- JWT (JSON Web Tokens)
- cURL (Integração com APIs externas)

**Frontend:**
- Flutter 3.x
- Provider (State Management)
- Video Player / Chewie
- Http Package

## 🤝 Contribuir
Sente-te à vontade para abrir Issues ou Pull Requests para melhorar o projeto.

---
**Desenvolvido com ❤️ e PHP**
