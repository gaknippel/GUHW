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
CREATE TABLE country (
    country_code CHAR(2) NOT NULL,
    country_name VARCHAR(60) NOT NULL,
    gdp INT NOT NULL,
    inflation NUMERIC(5, 1) NOT NULL,
    PRIMARY KEY (country_code)
);
CREATE TABLE province (
    province_name VARCHAR(30) NOT NULL,
    country_code CHAR(2) NOT NULL,
    area INT NOT NULL,
    PRIMARY KEY (province_name, country_code),
    FOREIGN KEY (country_code) REFERENCES country (country_code)
);
CREATE TABLE city (
    city_name VARCHAR(40) NOT NULL,
    province_name VARCHAR(30) NOT NULL,
    country_code CHAR(2) NOT NULL,
    population INT NOT NULL,
    PRIMARY KEY (city_name, province_name, country_code),
    FOREIGN KEY (province_name, country_code) REFERENCES province (province_name, country_code)
);
CREATE TABLE border (
    country_code_1 CHAR(2) NOT NULL,
    country_code_2 CHAR(2) NOT NULL,
    border_length INT NOT NULL,
    PRIMARY KEY (country_code_1, country_code_2),
    FOREIGN KEY (country_code_1) REFERENCES country (country_code),
    FOREIGN KEY (country_code_2) REFERENCES country (country_code),
    CHECK (country_code_1 <> country_code_2) --CHECK (country_code_1 < country_code_2)
);