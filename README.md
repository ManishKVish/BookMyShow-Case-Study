# BookMyShow: Database Design & Show Scheduling Case Study

[![MySQL Compatible](https://img.shields.io/badge/MySQL-8.0%2B-blue.svg)](https://www.mysql.com/)
[![Normalization](https://img.shields.io/badge/Normalization-1NF%20%7C%202NF%20%7C%203NF%20%7C%20BCNF-brightgreen.svg)]()
[![Airtribe Assignment](https://img.shields.io/badge/Airtribe-Backend%20System%20Design-orange.svg)]()

This repository contains the complete solution for the **BookMyShow Problem Solving Case** from Airtribe's Backend & System Design track.

---

## 📁 Repository Structure

```
├── sql/
│   ├── 01_schema.sql         # P1: Normalized DDL schema (1NF, 2NF, 3NF, BCNF)
│   ├── 02_sample_data.sql     # P1: Rich sample seed data across a 7-day schedule
│   └── 03_p2_queries.sql      # P2: Solution SQL queries for shows and timings
├── docs/
│   └── BookMyShow_System_Design.md  # Comprehensive design doc, normalization proofs, ER diagram
└── README.md                  # Project overview and execution instructions
```

---

## 🚀 Key Deliverables Included

1. **Problem P1: Entity Identification, Attribute Definition & Normalization**
   - Detailed breakdown of 13 entities (`cities`, `theatres`, `screens`, `seat_tiers`, `seats`, `movies`, `shows`, `show_seat_pricing`, `users`, `bookings`, `show_seats`, `booking_tickets`, `payments`).
   - Rigorous mathematical proofs establishing **1NF, 2NF, 3NF, and BCNF** compliance.
   - Executable MySQL script `sql/01_schema.sql` with foreign keys, checks, and B-Tree indexes.
   - Realistic seed script `sql/02_sample_data.sql` populating theatres, 30-seat auditoriums, pricing tiers, and movie schedules across 7 consecutive dates.

2. **Problem P2: Query for Shows & Show Timings on a Given Date at a Given Theatre**
   - Optimized, production-ready SQL query in `sql/03_p2_queries.sql`.
   - Aggregates movie title, language, format (IMAX, 4K Dolby Atmos, 2D), screen name, start time, end time, total seats, and real-time available seats.
   - Supplementary queries for grouping timings by movie and rendering 7-day schedule calendars.

3. **High-Concurrency Seat Reservation Strategy**
   - Two-phase seat locking (Redis distributed lock with 10-minute hold TTL + atomic SQL conditional update).
   - Invariant preservation preventing double booking of identical seats during traffic spikes.

---

## 💻 How to Run the SQL Scripts

The SQL scripts are directly executable on any MySQL 8.0+ instance:

```bash
# 1. Create schema
mysql -u root -p < sql/01_schema.sql

# 2. Seed sample data
mysql -u root -p < sql/02_sample_data.sql

# 3. Execute P2 query
mysql -u root -p < sql/03_p2_queries.sql
```
