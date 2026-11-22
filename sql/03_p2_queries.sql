-- ============================================================================
-- BookMyShow P2 Solution: Queries for Shows & Show Timings
-- ============================================================================

USE bookmyshow_db;

-- ============================================================================
-- Query P2.1: Primary Solution
-- List all shows running on a given date ('2026-12-01') at a given theatre (Theatre ID: 1)
-- with movie title, format, screen details, show timings, and seat availability.
-- ============================================================================

SELECT 
    t.name AS theatre_name,
    m.title AS movie_title,
    m.language AS movie_language,
    m.censor_rating,
    CONCAT(FLOOR(m.duration_minutes / 60), 'h ', MOD(m.duration_minutes, 60), 'm') AS movie_duration,
    s.format_type,
    sc.screen_name,
    TIME_FORMAT(s.start_time, '%h:%i %p') AS show_start_time,
    TIME_FORMAT(s.end_time, '%h:%i %p') AS show_end_time,
    s.show_date,
    sc.total_capacity,
    COALESCE(COUNT(CASE WHEN ss.status = 'AVAILABLE' THEN 1 END), sc.total_capacity) AS available_seats,
    CASE 
        WHEN COALESCE(COUNT(CASE WHEN ss.status = 'AVAILABLE' THEN 1 END), sc.total_capacity) = 0 THEN 'SOLD OUT'
        WHEN COALESCE(COUNT(CASE WHEN ss.status = 'AVAILABLE' THEN 1 END), sc.total_capacity) < 10 THEN 'FILLING FAST'
        ELSE 'AVAILABLE'
    END AS availability_status
FROM shows s
JOIN screens sc ON s.screen_id = sc.id
JOIN theatres t ON sc.theatre_id = t.id
JOIN movies m ON s.movie_id = m.id
LEFT JOIN show_seats ss ON s.id = ss.show_id
WHERE t.id = 1                           -- Given Theatre ID
  AND s.show_date = '2026-12-01'          -- Given Date
  AND s.status = 'ACTIVE'
GROUP BY 
    s.id, t.name, m.title, m.language, m.censor_rating, m.duration_minutes,
    s.format_type, sc.screen_name, s.start_time, s.end_time, s.show_date, sc.total_capacity
ORDER BY 
    s.start_time ASC;

-- ============================================================================
-- Query P2.2: Aggregated Show Timings Grouped by Movie
-- Formats output like BookMyShow UI where each movie card displays all its daily show timings
-- ============================================================================

SELECT 
    m.title AS movie_title,
    m.language,
    s.format_type,
    GROUP_CONCAT(
        CONCAT(
            TIME_FORMAT(s.start_time, '%h:%i %p'), 
            ' (', sc.screen_name, ')'
        ) 
        ORDER BY s.start_time ASC 
        SEPARATOR '  |  '
    ) AS daily_showtimes
FROM shows s
JOIN screens sc ON s.screen_id = sc.id
JOIN theatres t ON sc.theatre_id = t.id
JOIN movies m ON s.movie_id = m.id
WHERE t.id = 1
  AND s.show_date = '2026-12-01'
  AND s.status = 'ACTIVE'
GROUP BY m.id, m.title, m.language, s.format_type;

-- ============================================================================
-- Query P2.3: Next 7-Day Date Bar Overview
-- Displays the available dates and total active show counts for the theatre
-- ============================================================================

SELECT 
    s.show_date,
    DATE_FORMAT(s.show_date, '%a, %d %b') AS formatted_date,
    COUNT(DISTINCT s.id) AS total_shows_running,
    COUNT(DISTINCT s.movie_id) AS distinct_movies_playing
FROM shows s
JOIN screens sc ON s.screen_id = sc.id
WHERE sc.theatre_id = 1
  AND s.show_date BETWEEN '2026-12-01' AND DATE_ADD('2026-12-01', INTERVAL 6 DAY)
  AND s.status = 'ACTIVE'
GROUP BY s.show_date
ORDER BY s.show_date ASC;
