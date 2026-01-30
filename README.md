# Video Streaming App

A Full Stack Video Streaming application built with Flutter (frontend) and Node.js/Express (backend) with MySQL database.

## 🎯 Features

- User Authentication (Login/Register)
- Video Streaming with Chewie Player
- Category-based Video Filtering
- Favorite Videos
- Continue Watching (Save Playback Position)
- Clean Architecture (Flutter)
- RESTful API (Node.js/Express)

## 📁 Project Structure

```
video-streaming-app/
├── server/                 # Backend (Node.js/Express)
│   ├── config/            # Database configuration
│   ├── controllers/       # Request handlers
│   ├── models/           # Data models
│   ├── routes/           # API routes
│   ├── db/               # Database schema
│   ├── .env              # Environment variables
│   └── index.js          # Server entry point
│
└── app/                   # Frontend (Flutter)
    ├── lib/
    │   ├── models/       # Data models
    │   ├── services/     # API services
    │   ├── providers/    # State management
    │   ├── screens/      # UI screens
    │   └── widgets/      # Reusable widgets
    └── pubspec.yaml      # Dependencies
```

## 🚀 Getting Started

### Prerequisites

- Node.js (v14 or higher)
- MySQL (v8.0 or higher)
- Flutter (v3.0 or higher)
- Dart SDK

### Backend Setup

1. Navigate to the server directory:
   ```bash
   cd server
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Configure environment variables:
   - Open `.env` file
   - Update database credentials:
     ```
     DB_HOST=localhost
     DB_USER=root
     DB_PASS=your_password
     DB_NAME=video_streaming_db
     JWT_SECRET=your_secret_key
     PORT=3000
     ```

4. Create and seed the database:
   ```bash
   # Login to MySQL
   mysql -u root -p
   
   # Import the schema
   source db/schema.sql
   ```

5. Start the server:
   ```bash
   node index.js
   ```
   
   Server will run on `http://localhost:3000`

### Frontend Setup

1. Navigate to the app directory:
   ```bash
   cd app
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Update API endpoint:
   - Open `lib/services/api_service.dart`
   - Update `baseUrl` with your server IP (use your computer's IP address for testing on physical devices)

4. Run the app:
   ```bash
   # For Android/iOS emulator
   flutter run
   
   # For specific device
   flutter devices
   flutter run -d <device_id>
   ```

## 🔐 Test Credentials

Use these credentials to test the application:

- **Email:** test@example.com
- **Password:** test123

## 📱 Available Screens

1. **Login Screen** - User authentication
2. **Dashboard Screen** - Browse videos by category
3. **Library Screen** - Favorites and continue watching
4. **Player Screen** - Video playback with Chewie

## 🎨 Theme

The app uses a Netflix-inspired dark theme:
- Background: `#000000` (Black)
- Primary Color: `#E50914` (Netflix Red)
- Card Color: `#1A1A1A` (Dark Gray)

## 📦 Dependencies

### Backend
- express - Web framework
- mysql2 - MySQL client
- jsonwebtoken - JWT authentication
- bcryptjs - Password hashing
- cors - CORS middleware
- dotenv - Environment variables

### Frontend
- provider - State management
- http - HTTP requests
- video_player - Video playback
- chewie - Video player UI
- flutter_secure_storage - Secure token storage
- cached_network_image - Image caching
- intl - Date formatting

## 🔧 TODO: Implementation Tasks

The following features need to be implemented:

### Backend
- [ ] Complete authentication logic in `authController.js`
- [ ] Implement video CRUD operations in `videoController.js`
- [ ] Add JWT middleware for protected routes
- [ ] Implement user-video relationship queries

### Frontend
- [ ] Complete login/register functionality
- [ ] Implement video fetching from API
- [ ] Add favorite toggle functionality
- [ ] Implement playback position tracking
- [ ] Add category filtering
- [ ] Implement secure token storage

## 📝 API Endpoints

```
POST   /api/auth/login              - User login
POST   /api/auth/register           - User registration
GET    /api/videos                  - Get all videos
GET    /api/videos/:id              - Get video by ID
GET    /api/videos/category/:id     - Get videos by category
POST   /api/videos/:id/favorite     - Toggle favorite
PUT    /api/videos/:id/position     - Update playback position
```

## 🎥 Sample Videos

The database is seeded with public domain videos from Blender Open Movies:
- Big Buck Bunny
- Elephant Dream
- Sintel
- Tears of Steel

## 📄 License

This project is open source and available for educational purposes.

## 🤝 Contributing

This is a boilerplate project. Feel free to implement the TODO items and extend functionality as needed.

---

**Note:** This is a starter template with boilerplate code. Business logic implementation is required for full functionality.
