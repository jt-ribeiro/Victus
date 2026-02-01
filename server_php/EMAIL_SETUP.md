# Configuração de Email - Video Streaming App

Este projeto utiliza a **Resend API** para envio de emails transacionais (recuperação de password).
É mais rápido, seguro e confiável do que SMTP tradicional.

## 🚀 Como Configurar (5 Minutos)

### 1. Criar Conta no Resend
1. Acede a [Resend.com](https://resend.com) e cria uma conta grátis.
2. Vai a **API Keys** no menu lateral.
3. Cria uma nova chave (Copy/Paste da chave gerada, começa por `re_`).

### 2. Configurar o Backend
1. Abre o ficheiro `server_php/.env`.
2. Adiciona/Atualiza a seguinte linha:

```ini
RESEND_API_KEY=re_123456789...
```

### 3. Configurar Remetente (Sender)

#### Para Testes (Sem Domínio Próprio)
Se ainda não configuraste um domínio no Resend, tens de usar o email de teste deles E só podes enviar para o **teu próprio email** (o mesmo do registo).

```ini
MAIL_FROM=onboarding@resend.dev
MAIL_FROM_NAME=Video Streaming App
```

#### Para Produção (Domínio Verificado)
Depois de verificares o teu domínio no Resend (ex: `tuaempresa.com`):

```ini
MAIL_FROM=suporte@tuaempresa.com
MAIL_FROM_NAME=Video Streaming App
```

## 🧪 Testar Recuperação de Password

1. Certifica-te que o servidor PHP está a correr (`php -S localhost:3000`).
2. Abre a App Flutter.
3. No ecrã de Login, clica em **"Esqueci-me da palavra-passe"**.
4. Insere o teu email e clica em Enviar.
5. Verifica a tua caixa de entrada (e Spam).
6. Copia o **Código de 64 caracteres** ou clica no botão "Já tenho um código" na App.

## ⚠️ Resolução de Problemas

- **Não recebo emails:**
  - Verifica se o `RESEND_API_KEY` está correto no `.env`.
  - Se estás no plano grátis/teste, só podes enviar para **o teu próprio email**.
  - Verifica a pasta Spam.
  
- **Erro na App:**
  - Verifica os logs do servidor PHP na consola.
  - Se mudaste o `.env`, **reinicia o servidor PHP**.
