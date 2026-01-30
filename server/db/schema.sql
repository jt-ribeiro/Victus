-- Video Streaming Database Schema

-- Create database
CREATE DATABASE IF NOT EXISTS video_streaming_db;
USE video_streaming_db;

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories table
CREATE TABLE IF NOT EXISTS categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(50) NOT NULL
);

-- Videos table
CREATE TABLE IF NOT EXISTS videos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  thumbnail_url VARCHAR(500),
  video_url VARCHAR(500) NOT NULL,
  category_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- User Content table (favorites and playback position)
CREATE TABLE IF NOT EXISTS user_content (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  video_id INT NOT NULL,
  is_favorite BOOLEAN DEFAULT FALSE,
  last_position_seconds INT DEFAULT 0,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (video_id) REFERENCES videos(id) ON DELETE CASCADE,
  UNIQUE KEY unique_user_video (user_id, video_id)
);

-- Seed data: Categories
INSERT INTO categories (title) VALUES
('Action'),
('Drama'),
('Documentary'),
('Comedy'),
('Sci-Fi');

-- Seed data: Sample Videos (using public domain/sample videos)
INSERT INTO videos (title, description, thumbnail_url, video_url, category_id) VALUES
(
  'Big Buck Bunny',
  'A large and lovable rabbit deals with three tiny bullies, led by a flying squirrel.',
  'https://peach.blender.org/wp-content/uploads/title_anouncement.jpg',
  'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
  4
),
(
  'Elephant Dream',
  'The first Blender Open Movie from 2006. A strange and dreamlike fantasy film.',
  'https://orange.blender.org/wp-content/themes/orange/images/media/splash.jpg',
  'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
  5
),
(
  'For Bigger Blazes',
  'An action-packed adventure showcasing stunning visual effects.',
  'https://storage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerBlazes.jpg',
  'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
  1
),
(
  'Sintel',
  'A lonely young girl searches for her lost pet dragon in this emotional adventure.',
  'https://durian.blender.org/wp-content/uploads/2010/06/sintel-a.jpg',
  'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
  2
),
(
  'Tears of Steel',
  'A sci-fi short film about a group of warriors coming to terms with their past.',
  'https://mango.blender.org/wp-content/uploads/2012/09/01_thom_celia_bridge.jpg',
  'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
  5
),
(
  'For Bigger Escapes',
  'A documentary-style journey through breathtaking landscapes.',
  'https://storage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerEscapes.jpg',
  'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
  3
),
(
  'For Bigger Fun',
  'A comedy showcase of laugh-out-loud moments.',
  'https://storage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerFun.jpg',
  'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
  4
),
(
  'For Bigger Joyrides',
  'An adrenaline-fueled action sequence that will leave you breathless.',
  'https://storage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerJoyrides.jpg',
  'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
  1
);

-- Seed data: Test user (password: test123)
-- Password hash generated with bcryptjs: bcrypt.hashSync('test123', 10)
INSERT INTO users (name, email, password_hash) VALUES
('Test User', 'test@example.com', '$2a$10$9LvP8Kj7qRH.xK9tZ8sXf.YHCKGvN5wZLQJKZ0XqJ8rL8mP7yZqKm');
