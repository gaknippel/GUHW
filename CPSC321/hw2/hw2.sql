-- Greyson Knippel
-- CPSC-321, hw2


--drops 

DROP TABLE IF EXISTS crew_assignment;
DROP TABLE IF EXISTS crew_member;
DROP TABLE IF EXISTS booking;
DROP TABLE IF EXISTS passenger;
DROP TABLE IF EXISTS flight_route;
DROP TABLE IF EXISTS airline;
DROP TABLE IF EXISTS airport;

--tables

CREATE TABLE airport (
    air_id      CHAR(3)      NOT NULL,
    air_name    VARCHAR(40) NOT NULL,
    city        VARCHAR(20)  NOT NULL,
    state       CHAR(2)      NOT NULL,

    PRIMARY KEY (air_id)
);

CREATE TABLE airline (
    air_code    CHAR(2) NOT NULL,
    airline_name    VARCHAR(30) NOT NULL,
    air_id      CHAR(3) NOT NULL,
    founded_year    SMALLINT NOT NULL,

    PRIMARY KEY (air_code),
    FOREIGN KEY (air_id) REFERENCES airport(air_id)
);

CREATE TABLE flight_route (
    air_code    CHAR(2) NOT NULL,
    flight_num SMALLINT NOT NULL,
    dep_id      CHAR(3) NOT NULL,
    arr_id      CHAR(3) NOT NULL,
    distance    SMALLINT NOT NULL,

    PRIMARY KEY (air_code,flight_num),

    FOREIGN KEY (air_code) REFERENCES airline(air_code),
    FOREIGN KEY (dep_id) REFERENCES airport(air_id),
    FOREIGN KEY (arr_id) REFERENCES airport(air_id),

    
    CHECK (distance > 0),
    CHECK (dep_id != arr_id OR arr_id != dep_id)
);

CREATE TABLE passenger (
    pass_id SMALLINT NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    email VARCHAR(60) NOT NULL,

    PRIMARY KEY (pass_id),

    UNIQUE (email)
);


CREATE TABLE booking (
    pass_id SMALLINT NOT NULL,
    air_code    CHAR(2) NOT NULL,
    flight_num SMALLINT NOT NULL,
    travel_date DATE NOT NULL,
    seat        VARCHAR(4),
    price       NUMERIC(7,2) NOT NULL,

    PRIMARY KEY (pass_id, air_code, flight_num, travel_date),

    FOREIGN KEY (air_code,flight_num) REFERENCES flight_route(air_code,flight_num),
    FOREIGN KEY (pass_id) REFERENCES passenger(pass_id),


    CHECK (price >= 0),

    UNIQUE (air_code, flight_num, travel_date, seat)
);


--new tables

CREATE TABLE crew_member (
    crew_id     INT GENERATED ALWAYS AS IDENTITY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    hire_date DATE NOT NULL,
    end_date DATE,
    is_pilot BOOLEAN NOT NULL DEFAULT FALSE,
    supervisor_id INT,

    PRIMARY KEY (crew_id),

    FOREIGN KEY (supervisor_id) REFERENCES crew_member(crew_id),

    CHECK (end_date >= hire_date),
    CHECK (supervisor_id != crew_id OR crew_id != supervisor_id)
);


CREATE TABLE crew_assignment (
    crew_id INT NOT NULL,
    air_code    CHAR(2) NOT NULL,
    flight_num SMALLINT NOT NULL,
    travel_date DATE NOT NULL,
    shift_start TIMESTAMP NOT NULL,
    shift_end TIMESTAMP NOT NULL,


    PRIMARY KEY (crew_id, air_code, flight_num, travel_date),
    FOREIGN KEY (air_code,flight_num) REFERENCES flight_route(air_code,flight_num),
    FOREIGN KEY (crew_id) REFERENCES crew_member(crew_id),

    CHECK (shift_end > shift_start),
    CHECK (shift_end <= shift_start + INTERVAL '16 hours')
);


--inserts

INSERT INTO airport (air_id, air_name, city, state) VALUES
    ('GEG', 'Spokane International',          'Spokane',     'WA'),
    ('SEA', 'Seattle-Tacoma International',    'Seattle',     'WA'),
    ('LAX', 'Los Angeles International',       'Los Angeles', 'CA'),
    ('DEN', 'Denver International',            'Denver',      'CO'),
    ('JFK', 'John F. Kennedy International',   'New York',    'NY');


INSERT INTO passenger (pass_id, first_name, last_name, email) VALUES
    (1, 'Jack',    'Smith',   'jsmith@example.com'),
    (2, 'Alan',    'Cho',     'acho@example.com'),
    (3, 'Greyson', 'Knippel', 'gknippel@example.com'),
    (4, 'Maria',   'Delgado', 'mdelgado@example.com'),
    (5, 'Priya',   'Raman',   'praman@example.com');


INSERT INTO airline (air_code, airline_name, air_id, founded_year) VALUES
    ('AS', 'Alaska Airlines',    'SEA', 1932),
    ('WN', 'Southwest Airlines', 'LAX', 1967),
    ('UA', 'United Airlines',    'DEN', 1926),
    ('DL', 'Delta Air Lines',    'JFK', 1925),
    ('AA', 'American Airlines',  'LAX', 1930);



INSERT INTO flight_route (air_code, flight_num, dep_id, arr_id, distance) VALUES
    ('AS', 122, 'GEG', 'SEA',  224),
    ('AS', 345, 'SEA', 'LAX',  954),
    ('WN', 122, 'LAX', 'GEG', 1046),
    ('UA', 588, 'DEN', 'JFK', 1626),
    ('DL', 701, 'JFK', 'LAX', 2475);



INSERT INTO booking (pass_id, air_code, flight_num, travel_date, seat, price) VALUES
    (1, 'AS', 122, '2026-10-02', '14A', 189.50),
    (1, 'AS', 122, '2026-11-15', '08C', 210.00),
    (2, 'AS', 122, '2026-10-02', '14B', 205.75),
    (3, 'WN', 122, '2026-10-05', NULL,  156.25),
    (4, 'DL', 701, '2026-12-01', '02A', 645.00),
    (5, 'WN', 122, '2026-10-05', NULL,  161.00);



INSERT INTO crew_member (first_name, last_name, hire_date, end_date, is_pilot, supervisor_id) VALUES
    ('Dana', 'Weiss', '2015-03-01', NULL, TRUE, NULL),
    ('Omar', 'Diaz',  '2017-06-12', NULL, TRUE, NULL);

INSERT INTO crew_member (first_name, last_name, hire_date, end_date, is_pilot, supervisor_id) VALUES
    ('Lena', 'Petrov', '2019-01-20', NULL,         DEFAULT, 1),
    ('Sam',  'Okafor', '2020-09-05', NULL,         TRUE,    2),
    ('Iris', 'Chen',   '2021-04-18', '2026-02-28', FALSE,   2);



INSERT INTO crew_assignment (crew_id, air_code, flight_num, travel_date, shift_start, shift_end) VALUES
    (1, 'AS', 122, '2026-10-02', '2026-10-02 06:00', '2026-10-02 14:30'),
    (2, 'AS', 122, '2026-10-02', '2026-10-02 06:00', '2026-10-02 14:30'),
    (1, 'AS', 345, '2026-10-03', '2026-10-03 09:15', '2026-10-03 18:45'),
    (4, 'DL', 701, '2026-12-01', '2026-11-30 22:00', '2026-12-01 06:00'),
    (5, 'UA', 588, '2026-10-10', '2026-10-10 05:00', '2026-10-10 20:00');


-- failing inserts


-- duplicate primary key: 'GEG' is already the primary key of an
--    existing airport row.
-- INSERT INTO airport (air_id, air_name, city, state) VALUES
--     ('GEG', 'Duplicate Spokane', 'Spokane', 'WA');

-- foreign key violating: hub airport 'XXX' does not exist in airport.
-- INSERT INTO airline (air_code, airline_name, air_id, founded_year) VALUES
--     ('B6', 'JetBlue Airways', 'XXX', 2000);

-- non null violation: email cant be NOT NULL.
-- INSERT INTO passenger (pass_id, first_name, last_name, email) VALUES
--     (6, 'Nina', 'Ortiz', NULL);

-- check violation: departure and arrival airports must be different.
-- INSERT INTO flight_route (air_code, flight_num, dep_id, arr_id, distance) VALUES
--     ('AS', 999, 'GEG', 'GEG', 100);

-- check violation: booking price cant be negative.
-- INSERT INTO booking (pass_id, air_code, flight_num, travel_date, seat, price) VALUES
--     (2, 'DL', 701, '2026-12-05', '11C', -50.00);

-- unique violation: (not the primary key): email is a candidate key,
--    and this address already belongs to passenger 1.
-- INSERT INTO passenger (pass_id, first_name, last_name, email) VALUES
--     (7, 'Nate', 'Boyd', 'jsmith@example.com');

-- unique violation: (not the primary key): seat 14A on AS 122 for
--    2026-10-02 is already taken by another passenger.
-- INSERT INTO booking (pass_id, air_code, flight_num, travel_date, seat, price) VALUES
--     (3, 'AS', 122, '2026-10-02', '14A', 199.00);
















