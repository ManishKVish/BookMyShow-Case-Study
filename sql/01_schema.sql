-- ============================================================================
-- BookMyShow Relational Database Schema (MySQL 8.0+ Compatible)
-- Normalized to 1NF, 2NF, 3NF, and BCNF
-- ============================================================================

CREATE DATABASE IF NOT EXISTS bookmyshow_db;
USE bookmyshow_db;

-- 1. Cities
CREATE TABLE IF NOT EXISTS cities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL DEFAULT 'India',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_city_state (name, state)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Theatres
CREATE TABLE IF NOT EXISTS theatres (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    city_id INT NOT NULL,
    address TEXT NOT NULL,
    total_screens INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (city_id) REFERENCES cities(id) ON DELETE RESTRICT,
    INDEX idx_theatres_city (city_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Screens / Auditoriums
CREATE TABLE IF NOT EXISTS screens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    theatre_id INT NOT NULL,
    screen_number VARCHAR(20) NOT NULL,
    screen_name VARCHAR(100) NOT NULL,
    sound_system VARCHAR(50) DEFAULT 'Dolby Atmos',
    projection_type VARCHAR(50) DEFAULT 'Laser 4K',
    total_capacity INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (theatre_id) REFERENCES theatres(id) ON DELETE CASCADE,
    UNIQUE KEY uk_theatre_screen (theatre_id, screen_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Seat Tiers (Pricing categories per screen)
CREATE TABLE IF NOT EXISTS seat_tiers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE, -- e.g. 'RECLINER', 'PRIME', 'CLASSIC'
    description VARCHAR(255) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Physical Seats
CREATE TABLE IF NOT EXISTS seats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    screen_id INT NOT NULL,
    seat_tier_id INT NOT NULL,
    row_code VARCHAR(5) NOT NULL,     -- e.g. 'A', 'B', 'C'
    seat_number INT NOT NULL,         -- e.g. 1, 2, 3..
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (screen_id) REFERENCES screens(id) ON DELETE CASCADE,
    FOREIGN KEY (seat_tier_id) REFERENCES seat_tiers(id) ON DELETE RESTRICT,
    UNIQUE KEY uk_screen_seat (screen_id, row_code, seat_number),
    INDEX idx_seats_screen_tier (screen_id, seat_tier_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. Movies
CREATE TABLE IF NOT EXISTS movies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    language VARCHAR(50) NOT NULL,
    genre VARCHAR(100) NOT NULL,
    duration_minutes INT NOT NULL,
    censor_rating VARCHAR(10) NOT NULL DEFAULT 'UA',
    release_date DATE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_movie_language (language),
    INDEX idx_movie_release (release_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. Shows (Movie screening at a specific screen, date, and time)
CREATE TABLE IF NOT EXISTS shows (
    id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    screen_id INT NOT NULL,
    show_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    format_type VARCHAR(20) NOT NULL DEFAULT '2D', -- '2D', '3D', 'IMAX 2D', 'IMAX 3D', '4DX'
    status ENUM('UPCOMING', 'ACTIVE', 'CANCELLED', 'COMPLETED') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE RESTRICT,
    FOREIGN KEY (screen_id) REFERENCES screens(id) ON DELETE RESTRICT,
    UNIQUE KEY uk_screen_showtime (screen_id, show_date, start_time),
    INDEX idx_shows_date_screen (show_date, screen_id),
    INDEX idx_shows_movie (movie_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8. Show Pricing by Seat Tier (Dynamic pricing per show per tier)
CREATE TABLE IF NOT EXISTS show_seat_pricing (
    id INT AUTO_INCREMENT PRIMARY KEY,
    show_id INT NOT NULL,
    seat_tier_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (show_id) REFERENCES shows(id) ON DELETE CASCADE,
    FOREIGN KEY (seat_tier_id) REFERENCES seat_tiers(id) ON DELETE RESTRICT,
    UNIQUE KEY uk_show_tier_pricing (show_id, seat_tier_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9. Users
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 10. Bookings
CREATE TABLE IF NOT EXISTS bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_reference VARCHAR(50) NOT NULL UNIQUE,
    user_id INT NOT NULL,
    show_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    booking_status ENUM('PENDING', 'CONFIRMED', 'CANCELLED', 'EXPIRED') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
    FOREIGN KEY (show_id) REFERENCES shows(id) ON DELETE RESTRICT,
    INDEX idx_bookings_user (user_id),
    INDEX idx_bookings_show (show_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 11. Show Seat Inventory Status (Tracks seat state for each show: AVAILABLE, RESERVED, BOOKED)
CREATE TABLE IF NOT EXISTS show_seats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    show_id INT NOT NULL,
    seat_id INT NOT NULL,
    status ENUM('AVAILABLE', 'LOCKED', 'BOOKED') NOT NULL DEFAULT 'AVAILABLE',
    booking_id INT NULL,
    lock_expires_at TIMESTAMP NULL, -- 10-minute checkout hold TTL
    FOREIGN KEY (show_id) REFERENCES shows(id) ON DELETE CASCADE,
    FOREIGN KEY (seat_id) REFERENCES seats(id) ON DELETE RESTRICT,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE SET NULL,
    UNIQUE KEY uk_show_seat_instance (show_id, seat_id),
    INDEX idx_show_seat_status (show_id, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 12. Booking Tickets (Line items linking booked seats to booking)
CREATE TABLE IF NOT EXISTS booking_tickets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    show_seat_id INT NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
    FOREIGN KEY (show_seat_id) REFERENCES show_seats(id) ON DELETE RESTRICT,
    UNIQUE KEY uk_ticket_seat (show_seat_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 13. Payments
CREATE TABLE IF NOT EXISTS payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    payment_reference VARCHAR(100) NOT NULL UNIQUE,
    payment_method ENUM('UPI', 'CREDIT_CARD', 'DEBIT_CARD', 'NET_BANKING', 'WALLET') NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status ENUM('INITIATED', 'SUCCESS', 'FAILED', 'REFUNDED') NOT NULL DEFAULT 'INITIATED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE RESTRICT,
    INDEX idx_payments_booking (booking_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
