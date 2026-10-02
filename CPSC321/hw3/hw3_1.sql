/*============================================================
 * NAME: GREYSON KNIPPEL
 * ASSIGN: HW-3, Part 1
 * COURSE: CPSC 321, Fall 2026
 * DESC: Create and populate the "factbook" database tables.
 *============================================================*/
DROP TABLE IF EXISTS border;
DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS province;
DROP TABLE IF EXISTS country;
-- country: each country's code, name, gdp, and inflation
CREATE TABLE country (
    country_code CHAR(2) NOT NULL,
    country_name VARCHAR(60) NOT NULL,
    gdp INT NOT NULL,
    inflation NUMERIC(5, 1) NOT NULL,
    PRIMARY KEY (country_code)
);
-- province: a province within a country and its area in km^2
CREATE TABLE province (
    province_name VARCHAR(30) NOT NULL,
    country_code CHAR(2) NOT NULL,
    area INT NOT NULL,
    PRIMARY KEY (province_name, country_code),
    FOREIGN KEY (country_code) REFERENCES country (country_code)
);
-- city: a city within a province and its total population
CREATE TABLE city (
    city_name VARCHAR(40) NOT NULL,
    province_name VARCHAR(30) NOT NULL,
    country_code CHAR(2) NOT NULL,
    population INT NOT NULL,
    PRIMARY KEY (city_name, province_name, country_code),
    FOREIGN KEY (province_name, country_code) REFERENCES province (province_name, country_code)
);
-- border: a shared border between two different countries and its length in km
CREATE TABLE border (
    country_code_1 CHAR(2) NOT NULL,
    country_code_2 CHAR(2) NOT NULL,
    border_length INT NOT NULL,
    PRIMARY KEY (country_code_1, country_code_2),
    FOREIGN KEY (country_code_1) REFERENCES country (country_code),
    FOREIGN KEY (country_code_2) REFERENCES country (country_code),
    CHECK (country_code_1 <> country_code_2) --CHECK (country_code_1 < country_code_2)
);


INSERT INTO country VALUES
    ('US', 'United States of America', 46900, 3.8),
    ('CA', 'Canada', 43100, 2.4),
    ('MX', 'Mexico', 15300, 4.7),
    ('DE', 'Germany', 52100, 2.2);
INSERT INTO province VALUES 
    ('Washington', 'US', 184661),
    ('Oregon', 'US', 254799),
    ('Ontario', 'CA', 1076395),
    ('British Columbia', 'CA', 944735),
    ('Jalisco', 'MX', 78599),
    ('Sonora', 'MX', 179355),
    ('Bavaria', 'DE', 70550),
    ('Saxony', 'DE', 18450);
INSERT INTO city VALUES
    ('Seattle', 'Washington', 'US', 737015),
    ('Spokane', 'Washington', 'US', 228989),
    ('Vancouver', 'Washington', 'US', 190915),
    ('Portland', 'Oregon', 'US', 652503),
    ('Salem', 'Oregon', 'US', 175535),
    ('Eugene', 'Oregon', 'US', 176654),
    ('Toronto', 'Ontario', 'CA', 2794356),
    ('Ottawa', 'Ontario', 'CA', 1017449),
    ('Portland', 'Ontario', 'CA', 15000),
    ('Vancouver', 'British Columbia', 'CA', 662248),
    ('Victoria', 'British Columbia', 'CA', 91867),
    ('Kelowna', 'British Columbia', 'CA', 144576),
    ('Guadalajara', 'Jalisco', 'MX', 1385629),
    ('Zapopan', 'Jalisco', 'MX', 1476491),
    ('Tlaquepaque', 'Jalisco', 'MX', 687127),
    ('Hermosillo', 'Sonora', 'MX', 936263),
    ('Ciudad Obregon', 'Sonora', 'MX', 436484),
    ('Nogales', 'Sonora', 'MX', 264782),
    ('Munich', 'Bavaria', 'DE', 1512491),
    ('Nuremberg', 'Bavaria', 'DE', 523026),
    ('Neustadt', 'Bavaria', 'DE', 13000),
    ('Dresden', 'Saxony', 'DE', 563311),
    ('Leipzig', 'Saxony', 'DE', 616093),
    ('Neustadt', 'Saxony', 'DE', 12000);
INSERT INTO border VALUES
    ('MX', 'US', 3145),
    ('US', 'CA', 8891),
    ('CA', 'MX', 500);