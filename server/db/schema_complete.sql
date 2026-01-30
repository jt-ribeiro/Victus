-- Victus App - Complete Database Schema
-- Drop existing database and recreate
DROP DATABASE IF EXISTS video_streaming_db;
CREATE DATABASE video_streaming_db;
USE video_streaming_db;

-- =====================================================
-- USERS & AUTHENTICATION
-- =====================================================

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  avatar_url VARCHAR(500),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =====================================================
-- COURSES & CONTENT
-- =====================================================

CREATE TABLE courses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  thumbnail_url VARCHAR(500),
  thumbnail_color VARCHAR(7) DEFAULT '#E5E5E5',
  status ENUM('active', 'coming_soon', 'locked') DEFAULT 'active',
  order_index INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE lessons (
  id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT NOT NULL,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  video_url VARCHAR(500),
  thumbnail_url VARCHAR(500),
  duration_seconds INT DEFAULT 0,
  order_index INT DEFAULT 0,
  is_free BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

-- =====================================================
-- USER PROGRESS & INTERACTIONS
-- =====================================================

CREATE TABLE user_courses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  course_id INT NOT NULL,
  progress_percentage DECIMAL(5,2) DEFAULT 0.00,
  is_favorite BOOLEAN DEFAULT FALSE,
  started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  UNIQUE KEY unique_user_course (user_id, course_id)
);

CREATE TABLE user_lessons (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  lesson_id INT NOT NULL,
  is_completed BOOLEAN DEFAULT FALSE,
  is_favorite BOOLEAN DEFAULT FALSE,
  is_liked BOOLEAN DEFAULT FALSE,
  last_position_seconds INT DEFAULT 0,
  completed_at TIMESTAMP NULL,
  last_watched TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
  UNIQUE KEY unique_user_lesson (user_id, lesson_id)
);

-- =====================================================
-- EVENTS & ACTIVITIES
-- =====================================================

CREATE TABLE events (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  event_date DATE NOT NULL,
  event_type ENUM('masterclass', 'workshop', 'webinar', 'challenge') DEFAULT 'workshop',
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- USER PROGRESS TRACKING
-- =====================================================

CREATE TABLE user_progress (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  metric_type ENUM('weight', 'body_fat', 'muscle_mass', 'custom') DEFAULT 'weight',
  metric_name VARCHAR(100),
  current_value DECIMAL(10,2),
  target_value DECIMAL(10,2),
  unit VARCHAR(20) DEFAULT 'kg',
  progress_percentage DECIMAL(5,2) DEFAULT 0.00,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- =====================================================
-- COMMENTS & NOTES
-- =====================================================

CREATE TABLE comments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  lesson_id INT NOT NULL,
  comment_text TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
);

CREATE TABLE notes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  lesson_id INT NOT NULL,
  note_text TEXT NOT NULL,
  timestamp_seconds INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
);

-- =====================================================
-- MATERIALS & DOWNLOADS
-- =====================================================

CREATE TABLE materials (
  id INT AUTO_INCREMENT PRIMARY KEY,
  lesson_id INT NOT NULL,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  file_url VARCHAR(500),
  file_type VARCHAR(50),
  file_size_mb DECIMAL(10,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
);

-- =====================================================
-- SEED DATA
-- =====================================================

-- Insert test user (password: test123)
INSERT INTO users (name, email, password_hash, avatar_url) VALUES
('Cristiana', 'test@example.com', '$2a$10$9LvP8Kj7qRH.xK9tZ8sXf.YHCKGvN5wZLQJKZ0XqJ8rL8mP7yZqKm', NULL);

-- Insert courses
INSERT INTO courses (title, description, thumbnail_color, status, order_index) VALUES
('Liberdade Alimentar', 'Aprende a ter uma relação saudável com a comida e alcança os teus objetivos de forma sustentável.', '#8B2635', 'active', 1),
('Olimpo', 'Corpo e mente invencíveis. Treinos e mindset para transformação completa.', '#2C2C2C', 'active', 2),
('Joanaflix', 'Desvenda o poder da nutrição com aulas didáticas e práticas.', '#1A1A1A', 'active', 3),
('Workshops', 'Sessões práticas e interativas sobre temas específicos de nutrição e bem-estar.', '#E5E5E5', 'active', 4),
('Masterclasses', 'Aulas aprofundadas com especialistas sobre tópicos avançados.', '#E5E5E5', 'active', 5),
('Desafio Corpo & Mente Sã', 'Desafio de 30 dias para transformar corpo e mente.', '#E5E5E5', 'coming_soon', 6);

-- Insert lessons for "Liberdade Alimentar" (course_id = 1)
INSERT INTO lessons (course_id, title, description, video_url, duration_seconds, order_index, is_free) VALUES
(1, 'Boas-vindas', 'Introdução ao programa Liberdade Alimentar e o que vais aprender.', 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4', 180, 1, TRUE),
(1, 'Métodos e princípios', 'Os fundamentos da alimentação consciente e sustentável.', 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4', 420, 2, TRUE),
(1, 'Guias Alimentares', 'Como utilizar os guias alimentares para planear as tuas refeições.', 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4', 360, 3, FALSE),
(1, 'Alimentação Saudável', 'O que é realmente uma alimentação saudável e equilibrada.', 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4', 480, 4, FALSE),
(1, 'Emagrecimento', 'Estratégias eficazes e saudáveis para perder peso.', 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4', 540, 5, FALSE),
(1, 'Planeamento Alimentar', 'Como planear as tuas refeições para a semana.', 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4', 600, 6, FALSE);

-- Insert lessons for "Olimpo" (course_id = 2)
INSERT INTO lessons (course_id, title, description, video_url, duration_seconds, order_index, is_free) VALUES
(2, 'Introdução ao Olimpo', 'Bem-vindo ao programa de transformação física e mental.', 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4', 240, 1, TRUE),
(2, 'Treino de Força', 'Fundamentos do treino de força para ganho muscular.', 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4', 900, 2, FALSE);

-- Insert lessons for "Joanaflix" (course_id = 3)
INSERT INTO lessons (course_id, title, description, video_url, duration_seconds, order_index, is_free) VALUES
(3, 'Nutrição Básica', 'Os fundamentos da nutrição explicados de forma simples.', 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4', 300, 1, TRUE),
(3, 'Macronutrientes', 'Proteínas, carboidratos e gorduras: o que precisas saber.', 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4', 420, 2, FALSE);

-- Insert user progress for test user
INSERT INTO user_courses (user_id, course_id, progress_percentage, is_favorite) VALUES
(1, 1, 80.00, TRUE),
(1, 2, 25.00, FALSE),
(1, 3, 10.00, FALSE);

-- Mark first lesson as completed
INSERT INTO user_lessons (user_id, lesson_id, is_completed, is_liked, is_favorite, completed_at) VALUES
(1, 1, TRUE, TRUE, FALSE, NOW()),
(1, 2, FALSE, FALSE, FALSE, NULL);

-- Insert events
INSERT INTO events (title, description, event_date, event_type) VALUES
('Masterclass de Nutrição', 'Sessão especial sobre nutrição avançada com convidados especiais.', '2026-05-23', 'masterclass'),
('Workshop de Planeamento', 'Workshop prático sobre como planear refeições saudáveis.', '2026-08-12', 'workshop'),
('Webinar: Emagrecimento Saudável', 'Sessão online sobre estratégias de emagrecimento sustentável.', '2026-09-15', 'webinar');

-- Insert user progress (weight tracking)
INSERT INTO user_progress (user_id, metric_type, metric_name, current_value, target_value, unit, progress_percentage) VALUES
(1, 'weight', 'Peso Perdido', 2.00, 10.00, 'kg', 20.00);

-- Insert sample comments
INSERT INTO comments (user_id, lesson_id, comment_text) VALUES
(1, 1, 'Adorei esta aula! Muito esclarecedora.');

-- Insert sample notes
INSERT INTO notes (user_id, lesson_id, note_text, timestamp_seconds) VALUES
(1, 1, 'Lembrar: começar com pequenas mudanças', 120);

-- Insert sample materials
INSERT INTO materials (lesson_id, title, description, file_url, file_type, file_size_mb) VALUES
(1, 'Guia de Boas-vindas PDF', 'Documento com resumo da aula e exercícios práticos.', 'https://example.com/materials/guia-boas-vindas.pdf', 'PDF', 2.5),
(3, 'Tabela de Guias Alimentares', 'Tabela prática para impressão com os guias alimentares.', 'https://example.com/materials/guias-alimentares.pdf', 'PDF', 1.8);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

CREATE INDEX idx_user_courses_user ON user_courses(user_id);
CREATE INDEX idx_user_lessons_user ON user_lessons(user_id);
CREATE INDEX idx_lessons_course ON lessons(course_id);
CREATE INDEX idx_comments_lesson ON comments(lesson_id);
CREATE INDEX idx_notes_lesson ON notes(lesson_id);
CREATE INDEX idx_events_date ON events(event_date);
