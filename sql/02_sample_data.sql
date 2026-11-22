-- ============================================================================
-- BookMyShow Sample Data Seed (Realistic 7-Day Show Schedule)
-- ============================================================================

USE bookmyshow_db;

-- 1. Cities
INSERT INTO cities (id, name, state) VALUES
(1, 'Mumbai', 'Maharashtra'),
(2, 'Bengaluru', 'Karnataka'),
(3, 'Delhi NCR', 'Delhi');

-- 2. Theatres
INSERT INTO theatres (id, name, city_id, address, total_screens) VALUES
(1, 'PVR ICON: Phoenix Palladium', 1, '462, Senapati Bapat Marg, Lower Parel, Mumbai', 4),
(2, 'INOX Megaplex: Inorbit Mall', 1, 'Link Road, Malad West, Mumbai', 5),
(3, 'PVR: Forum Mall Koramangala', 2, 'Hosur Road, Koramangala, Bengaluru', 6);

-- 3. Screens
INSERT INTO screens (id, theatre_id, screen_number, screen_name, sound_system, projection_type, total_capacity) VALUES
(1, 1, 'SCR-1', 'Audi 1 - IMAX Laser', 'Dolby 12-Channel', 'IMAX 4K Dual Laser', 30),
(2, 1, 'SCR-2', 'Audi 2 - Dolby Atmos', 'Dolby Atmos 64-Ch', 'Barco 4K RGB Laser', 30),
(3, 1, 'SCR-3', 'Audi 3 - Gold Class', 'Dolby 7.1 Surround', 'Christie 2K Laser', 20),
(4, 2, 'SCR-1', 'Audi 1 - INSIGNIA', 'Dolby Atmos', '4K Laser', 40);

-- 4. Seat Tiers
INSERT INTO seat_tiers (id, name, description) VALUES
(1, 'CLASSIC', 'Standard comfortable seating in the front and mid section'),
(2, 'PRIME', 'Premium viewing angle with wider push-back seating'),
(3, 'RECLINER', 'Luxury motorized leather recliners with in-seat food service');

-- 5. Seats for Audi 1 (30 seats: 10 Classic, 10 Prime, 10 Recliner)
-- Row A: Recliner (1..10)
INSERT INTO seats (screen_id, seat_tier_id, row_code, seat_number) VALUES
(1, 3, 'A', 1), (1, 3, 'A', 2), (1, 3, 'A', 3), (1, 3, 'A', 4), (1, 3, 'A', 5),
(1, 3, 'A', 6), (1, 3, 'A', 7), (1, 3, 'A', 8), (1, 3, 'A', 9), (1, 3, 'A', 10);

-- Row B: Prime (1..10)
INSERT INTO seats (screen_id, seat_tier_id, row_code, seat_number) VALUES
(1, 2, 'B', 1), (1, 2, 'B', 2), (1, 2, 'B', 3), (1, 2, 'B', 4), (1, 2, 'B', 5),
(1, 2, 'B', 6), (1, 2, 'B', 7), (1, 2, 'B', 8), (1, 2, 'B', 9), (1, 2, 'B', 10);

-- Row C: Classic (1..10)
INSERT INTO seats (screen_id, seat_tier_id, row_code, seat_number) VALUES
(1, 1, 'C', 1), (1, 1, 'C', 2), (1, 1, 'C', 3), (1, 1, 'C', 4), (1, 1, 'C', 5),
(1, 1, 'C', 6), (1, 1, 'C', 7), (1, 1, 'C', 8), (1, 1, 'C', 9), (1, 1, 'C', 10);

-- 6. Movies
INSERT INTO movies (id, title, language, genre, duration_minutes, censor_rating, release_date, description) VALUES
(1, 'Dune: Part Two', 'English', 'Sci-Fi/Action', 166, 'UA', '2026-03-01', 'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators.'),
(2, 'Oppenheimer', 'English', 'Biography/Drama', 180, 'A', '2026-07-21', 'The story of American scientist J. Robert Oppenheimer and his role in the development of the atomic bomb.'),
(3, 'Fighter', 'Hindi', 'Action/Thriller', 166, 'UA', '2026-01-25', 'An elite Air Force squadron faces perilous missions and inner turmoil to defend national sovereignty.');

-- 7. 7-Day Show Schedule for PVR ICON: Phoenix Palladium (Theatre ID 1)
-- Next 7 Dates: 2026-12-01 through 2026-12-07
INSERT INTO shows (id, movie_id, screen_id, show_date, start_time, end_time, format_type, status) VALUES
-- Day 1: 2026-12-01
(1, 1, 1, '2026-12-01', '10:00:00', '13:00:00', 'IMAX 2D', 'ACTIVE'),
(2, 1, 1, '2026-12-01', '14:30:00', '17:30:00', 'IMAX 2D', 'ACTIVE'),
(3, 1, 1, '2026-12-01', '19:00:00', '22:00:00', 'IMAX 2D', 'ACTIVE'),
(4, 2, 2, '2026-12-01', '11:15:00', '14:30:00', '4K Dolby Atmos', 'ACTIVE'),
(5, 3, 2, '2026-12-01', '18:30:00', '21:30:00', '2D', 'ACTIVE'),

-- Day 2: 2026-12-02
(6, 1, 1, '2026-12-02', '10:00:00', '13:00:00', 'IMAX 2D', 'ACTIVE'),
(7, 1, 1, '2026-12-02', '19:00:00', '22:00:00', 'IMAX 2D', 'ACTIVE'),
(8, 2, 2, '2026-12-02', '15:00:00', '18:15:00', '4K Dolby Atmos', 'ACTIVE'),

-- Day 3: 2026-12-03
(9, 1, 1, '2026-12-03', '14:00:00', '17:00:00', 'IMAX 2D', 'ACTIVE'),
(10, 3, 2, '2026-12-03', '20:00:00', '23:00:00', '2D', 'ACTIVE'),

-- Day 4: 2026-12-04
(11, 1, 1, '2026-12-04', '11:00:00', '14:00:00', 'IMAX 2D', 'ACTIVE'),
(12, 2, 2, '2026-12-04', '18:00:00', '21:15:00', '4K Dolby Atmos', 'ACTIVE'),

-- Day 5: 2026-12-05
(13, 1, 1, '2026-12-05', '15:30:00', '18:30:00', 'IMAX 2D', 'ACTIVE'),
(14, 3, 2, '2026-12-05', '21:00:00', '23:55:00', '2D', 'ACTIVE'),

-- Day 6: 2026-12-06
(15, 1, 1, '2026-12-06', '10:00:00', '13:00:00', 'IMAX 2D', 'ACTIVE'),
(16, 2, 2, '2026-12-06', '16:00:00', '19:15:00', '4K Dolby Atmos', 'ACTIVE'),

-- Day 7: 2026-12-07
(17, 1, 1, '2026-12-07', '18:00:00', '21:00:00', 'IMAX 2D', 'ACTIVE'),
(18, 3, 2, '2026-12-07', '21:30:00', '00:25:00', '2D', 'ACTIVE');

-- 8. Show Pricing Configuration
-- Show 1 (IMAX 2D) Pricing
INSERT INTO show_seat_pricing (show_id, seat_tier_id, price) VALUES
(1, 1, 350.00), -- Classic: INR 350
(1, 2, 550.00), -- Prime: INR 550
(1, 3, 900.00), -- Recliner: INR 900

(2, 1, 400.00),
(2, 2, 600.00),
(2, 3, 1000.00),

(3, 1, 450.00),
(3, 2, 650.00),
(3, 3, 1100.00);

-- 9. Initialize Show Seat Status for Show 1 (30 Seats)
-- 25 AVAILABLE, 3 BOOKED, 2 LOCKED
INSERT INTO show_seats (id, show_id, seat_id, status) VALUES
(1, 1, 1, 'BOOKED'),
(2, 1, 2, 'BOOKED'),
(3, 1, 3, 'BOOKED'),
(4, 1, 4, 'LOCKED'),
(5, 1, 5, 'LOCKED'),
(6, 1, 6, 'AVAILABLE'),
(7, 1, 7, 'AVAILABLE'),
(8, 1, 8, 'AVAILABLE'),
(9, 1, 9, 'AVAILABLE'),
(10, 1, 10, 'AVAILABLE');

-- Rows B and C all AVAILABLE
INSERT INTO show_seats (show_id, seat_id, status)
SELECT 1, s.id, 'AVAILABLE' FROM seats s WHERE s.screen_id = 1 AND s.row_code IN ('B', 'C');

-- 10. Sample Users
INSERT INTO users (id, name, email, phone) VALUES
(1, 'Rohan Mehta', 'rohan@example.com', '+919820011223'),
(2, 'Priya Nair', 'priya@example.com', '+919820099887');

-- 11. Sample Confirmed Booking
INSERT INTO bookings (id, booking_reference, user_id, show_id, total_amount, booking_status) VALUES
(1, 'BMS-MUM-20261201-001', 1, 1, 2700.00, 'CONFIRMED');

-- 12. Booking Tickets
INSERT INTO booking_tickets (booking_id, show_seat_id, ticket_price) VALUES
(1, 1, 900.00),
(1, 2, 900.00),
(1, 3, 900.00);

-- 13. Payments
INSERT INTO payments (booking_id, payment_reference, payment_method, amount, status) VALUES
(1, 'PAY-UPI-20261201-987654', 'UPI', 2700.00, 'SUCCESS');
