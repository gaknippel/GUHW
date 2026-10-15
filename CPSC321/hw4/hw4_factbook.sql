/*============================================================
 * NAME: GREYSON KNIPPEL
 * ASSIGN: HW-4
 * COURSE: CPSC 321, Fall 2026
 * DESC: factbook table from hw3, modified for hw4.
 *============================================================*/


DROP VIEW IF EXISTS border_full;
DROP FUNCTION IF EXISTS large_cities;
DROP PROCEDURE IF EXISTS add_province;
DEALLOCATE ALL;


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


INSERT INTO country VALUES /* added country w/ gdp per capita tied with DE. all other requirements were already here. */
    ('IS', 'Iceland', 52100, 3.1);


-- question 1: border_full lists every border in both directions,
-- using UNION to combine the stored rows with their flipped copies
CREATE VIEW border_full AS
    SELECT country_code_1, country_code_2, border_length
    FROM border
    UNION
    SELECT country_code_2, country_code_1, border_length
    FROM border;

SELECT * FROM border_full;

-- question 2: countries with a higher gdp and lower inflation than a
-- bordering country, where the border length > 400 (same as hw3)
SELECT DISTINCT c1.country_code, c1.country_name
FROM country c1
    JOIN border_full b ON c1.country_code = b.country_code_1
    JOIN country c2 ON b.country_code_2 = c2.country_code
WHERE b.border_length > 400
  AND c1.gdp > c2.gdp
  AND c1.inflation < c2.inflation;

-- question 3: countries that do not border any other country,
-- all countries EXCEPT the ones that appear in border_full
SELECT country_code, country_name
FROM country
EXCEPT
SELECT c.country_code, c.country_name
FROM country c
    JOIN border_full b ON c.country_code = b.country_code_1;

-- question 4: countries that do not border any other country,
-- using a LEFT JOIN and keeping the countries with no matching border
SELECT country_code, country_name
FROM country c,
LEFT JOIN border_full b ON c.country_code = b.country_code_1
WHERE b.country_code_1 IS NULL;


-- question 5: countries with the highest gdp per capita,
-- all countries EXCEPT those with a lower gdp than some other country
SELECT country_code, country_name, gdp
FROM country
EXCEPT
SELECT c1.country_code, c1.country_name, c1.gdp
FROM country c1
    JOIN country c2 ON c1.gdp < c2.gdp;

-- question 6: cities in a given country with population >= a given minimum
PREPARE country_cities(CHAR(2), INT) AS
    SELECT city_name, province_name, population
    FROM city
    WHERE country_code = $1
    AND population >= $2;

-- first execution: germany, min population 563311
EXECUTE country_cities('DE', 563311);

-- second execution US, min population 200000
EXECUTE country_cities('US', 200000);

-- question 7: stored function with the same parameters and columns as question 6
CREATE FUNCTION large_cities(code CHAR(2), min_pop INT)
RETURNS TABLE (city_name VARCHAR(40), province_name VARCHAR(30), population INT)
AS $$
    SELECT c.city_name, c.province_name, c.population
    FROM city c
    WHERE c.country_code = code
      AND c.population >= min_pop;
$$ LANGUAGE SQL;

-- call it with the same values as the first execute (germany, 563311),
-- adding each city's province area, sorted by population large to small
SELECT lc.city_name, lc.population, lc.province_name, p.area
FROM large_cities('DE', 563311) lc
    JOIN province p ON lc.province_name = p.province_name
                   AND p.country_code = 'DE'
ORDER BY lc.population DESC;

-- question 8: stored procedure that adds a province, then a city in that province
-- (province first)
CREATE PROCEDURE add_province (code CHAR(2), prov_name VARCHAR(30), prov_area INT, city_nm VARCHAR(40), city_pop INT)
LANGUAGE SQL
AS  $$
    INSERT INTO province VALUES (prov_name, code, prov_area);
    INSERT INTO city VALUES (city_nm, prov_name, code, city_pop);
$$;

-- add quebec (canada) and montreal, then show the new province and city
CALL add_province('CA', 'Quebec', 1542056, 'Montreal', 1762949);

SELECT p.province_name, p.country_code, p.area, c.city_name, c.population
FROM province p
    JOIN city c ON p.province_name = c.province_name
               AND p.country_code = c.country_code
WHERE p.province_name = 'Quebec'
  AND p.country_code = 'CA';