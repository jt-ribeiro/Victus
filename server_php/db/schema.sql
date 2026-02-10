-- Database Schema & Seeds
-- Run this in phpMyAdmin to setup the full database

-- 1. Create Database (Optional if already selected)
CREATE DATABASE IF NOT EXISTS video_streaming_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE video_streaming_db;

-- 2. Drop tables if they exist (to start fresh)
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS password_reset_tokens;
DROP TABLE IF EXISTS user_lessons;
DROP TABLE IF EXISTS user_courses;
DROP TABLE IF EXISTS lessons;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

-- 3. Create Users Table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    avatar_url VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Create Password Reset Tokens Table
CREATE TABLE password_reset_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token VARCHAR(64) NOT NULL UNIQUE,
    expires_at DATETIME NOT NULL,
    used TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_token (token),
    INDEX idx_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Create Categories
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Create Courses (Videos/Series)
CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    thumbnail_url VARCHAR(255),
    thumbnail_color VARCHAR(20) DEFAULT '#1A1A1A',
    is_featured BOOLEAN DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6.5 Create User Courses (Favorites & Progress)
CREATE TABLE user_courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    progress_percentage INT DEFAULT 0,
    is_favorite BOOLEAN DEFAULT 0,
    last_accessed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_course (user_id, course_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. Create Lessons (Episodes)
CREATE TABLE lessons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    video_url VARCHAR(255) NOT NULL,
    duration_seconds INT DEFAULT 0,
    position INT DEFAULT 0, -- Order in the course
    is_free BOOLEAN DEFAULT 0, -- First lesson usually free
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. Create User Lessons (Progress & Likes)
CREATE TABLE user_lessons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    lesson_id INT NOT NULL,
    last_position_seconds INT DEFAULT 0,
    is_completed BOOLEAN DEFAULT 0,
    is_favorite BOOLEAN DEFAULT 0,
    is_liked BOOLEAN DEFAULT 0,
    last_watched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_lesson (user_id, lesson_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- SEEDS (Initial Data)
-- ==========================================

-- Insert Test User (password: 123456)
INSERT INTO users (name, email, password_hash) VALUES 
('Cristiana', 'teste@victus.app', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi');

-- Insert Categories
INSERT INTO categories (name, slug) VALUES 
('Yoga', 'yoga'),
('Meditação', 'meditacao'),
('Pilates', 'pilates');

-- Insert Courses
INSERT INTO courses (category_id, title, description, thumbnail_url, thumbnail_color) VALUES 
(1, 'Introdução ao Yoga', 'Curso básico para iniciantes.', 'https://img.freepik.com/free-photo/young-woman-doing-yoga-outdoors_144627-995.jpg', '#D4989E'),
(2, 'Meditação Matinal', 'Começa o dia com energia.', 'https://img.freepik.com/free-photo/meditating-woman-nature_1098-1422.jpg', '#A5D6A7');

-- Insert Lessons for "Introdução ao Yoga"
INSERT INTO lessons (course_id, title, description, video_url, duration_seconds, position, is_free) VALUES 
(1, 'Aula 1: Respiração', 'Aprende a respirar corretamente.', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4', 600, 1, 1),
(1, 'Aula 2: Saudação ao Sol', 'Movimentos básicos.', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4', 900, 2, 0),
(1, 'Aula 3: Relaxamento', 'Técnicas de relaxamento final.', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4', 300, 3, 0);

-- Insert Lessons for "Meditação Matinal"
INSERT INTO lessons (course_id, title, description, video_url, duration_seconds, position, is_free) VALUES 
(2, 'Mindfulness Básico', 'Foco no presente.', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4', 300, 1, 1);
