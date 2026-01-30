# 🚀 Guia de Configuração - Victus App

## Pré-requisitos

### Para o Backend (Node.js)
- ✅ Node.js já instalado
- ✅ MySQL instalado
- ✅ Dependências já instaladas (`npm install` já foi executado)

### Para o Frontend (Flutter)
- 🔧 Flutter SDK (precisa ser instalado)

---

## 📋 Passo a Passo

### 1. Configurar Base de Dados MySQL

#### 1.1. Abrir MySQL
```bash
mysql -u root -p
```

#### 1.2. Executar o schema
```sql
source d:/Projetos/video-streaming-app/server/db/schema.sql
```

Isto vai criar:
- Base de dados `video_streaming_db`
- Tabelas: users, categories, videos, user_content
- Dados de teste (8 vídeos + 1 utilizador teste)

#### 1.3. Configurar variáveis de ambiente
Edita o ficheiro `server/.env`:
```env
DB_HOST=localhost
DB_USER=root
DB_PASS=a_tua_password_mysql
DB_NAME=video_streaming_db
JWT_SECRET=victus_secret_key_2026
PORT=3000
```

---

### 2. Iniciar o Servidor Backend

```powershell
# Na pasta video-streaming-app/server
cd d:\Projetos\video-streaming-app\server
node index.js
```

✅ Deves ver: **"Server is running on port 3000"**

Podes testar em: http://localhost:3000

---

### 3. Instalar Flutter SDK (se ainda não tiveres)

#### Opção 1: Instalação Manual
1. Acede a: https://docs.flutter.dev/get-started/install/windows
2. Descarrega o Flutter SDK
3. Extrai para `C:\src\flutter`
4. Adiciona `C:\src\flutter\bin` ao PATH do Windows
5. Executa: `flutter doctor`

#### Opção 2: Usar Chocolatey (mais rápido)
```powershell
# Instala o Chocolatey (se não tiveres)
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Instala o Flutter
choco install flutter -y

# Verifica a instalação
flutter doctor
```

---

### 4. Configurar Plataformas Flutter

Como criámos a estrutura manualmente, precisas de gerar os ficheiros de plataforma:

```powershell
cd d:\Projetos\video-streaming-app

# Remove a pasta app actual
Remove-Item -Recurse -Force app

# Cria um novo projeto Flutter
flutter create app --platforms=web,windows

# Copia os ficheiros que criámos
# (não te preocupes, vou fazer isto automaticamente)
```

**OU usa a estrutura já criada:**

```powershell
cd d:\Projetos\video-streaming-app\app

# Instala as dependências
flutter pub get

# Ativa web support
flutter config --enable-web

# Ativa windows desktop
flutter config --enable-windows-desktop
```

---

### 5. Copiar os Ficheiros da App

Se recriaste o projeto Flutter, precisa de copiar os nossos ficheiros:

```powershell
# Os nossos ficheiros estão em:
# - app/lib/models/
# - app/lib/services/
# - app/lib/providers/
# - app/lib/screens/
# - app/lib/widgets/
# - app/lib/main.dart
# - app/pubspec.yaml

# Copia tudo para o novo projeto
```

---

### 6. Correr a Aplicação Flutter

#### Para Web (Chrome)
```powershell
cd d:\Projetos\video-streaming-app\app
flutter run -d chrome
```

#### Para Windows Desktop
```powershell
cd d:\Projetos\video-streaming-app\app
flutter run -d windows
```

#### Ver dispositivos disponíveis
```powershell
flutter devices
```

---

## 🧪 Testar a Aplicação

### Credenciais de Teste
- **Email**: test@example.com
- **Password**: test123

### Endpoints da API
- http://localhost:3000 - Health check
- http://localhost:3000/api/videos - Lista de vídeos
- http://localhost:3000/api/auth/login - Login

---

## ❌ Problemas Comuns

### "Flutter not found"
- Certifica-te que adicionaste o Flutter ao PATH
- Reinicia o PowerShell/Terminal

### "Failed to connect to database"
- Verifica se o MySQL está a correr
- Confirma as credenciais no `.env`
- Testa a ligação: `mysql -u root -p`

### "Package not found" no Flutter
- Executa: `flutter pub get`
- Se persistir: `flutter clean` depois `flutter pub get`

### Porta 3000 já em uso
- Muda a porta no `.env`: `PORT=3001`
- Actualiza também no `app/lib/services/api_service.dart`

---

## 🎯 Solução Rápida (TL;DR)

```powershell
# Terminal 1 - Backend
cd d:\Projetos\video-streaming-app\server
node index.js

# Terminal 2 - Frontend (depois de instalar Flutter)
cd d:\Projetos\video-streaming-app\app
flutter pub get
flutter run -d chrome
```

---

## 📞 Próximos Passos

1. ✅ Configurar MySQL e criar base de dados
2. ✅ Iniciar servidor backend
3. 🔧 Instalar Flutter SDK
4. 📱 Correr aplicação Flutter
5. 🎨 Implementar lógica de autenticação
6. 🎬 Implementar reprodução de vídeos

---

**Nota**: Como o Flutter não estava instalado quando criámos o projeto, a estrutura de pastas android/ios/web pode estar incompleta. Podes precisar de recriar o projeto Flutter mantendo apenas a pasta `lib/` e o `pubspec.yaml`.
