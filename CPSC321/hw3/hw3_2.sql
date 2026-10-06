/*============================================================
 * NAME: GREYSON KNIPPEL
 * ASSIGN: HW-3, Part 2
 * COURSE: CPSC 321, Fall 2026
 * DESC: Queries 1-10 over the "factbook" database tables.
 *============================================================*/

--PART 2--

 --QUERY 1: provinces with area > 100000 in countries with gdp > 40000.
 SELECT c.country_code, c.country_name, c.gdp, p.province_name, p.area 
 FROM country c, province p
 WHERE c.country_code = p.country_code
    AND p.area > 100000
    AND c.gdp > 40000
ORDER BY c.gdp DESC, c.country_code ASC, p.area DESC;  

--QUERY 2: query 1 with join syntax instead of commas.
SELECT c.country_code, c.country_name, c.gdp, p.province_name, p.area
FROM country c
    JOIN province p ON c.country_code = p.country_code
WHERE p.area > 100000
    AND c.gdp > 40000
ORDER BY c.gdp DESC, c.country_code ASC, p.area DESC;

--QUERY 3: provinces with area < 100000 that have at least one city
--         with population between 10000 and 300000 (inclusive).
SELECT DISTINCT p.country_code, p.province_name, p.area
FROM province p, city ci
WHERE p.province_name = ci.province_name
    AND p.country_code = ci.country_code
    AND p.area < 100000
    AND ci.population >= 10000
    AND ci.population <= 300000;

--QUERY 4: q3 written with join syntax
SELECT DISTINCT p.country_code, p.province_name, p.area
FROM province p
    JOIN city ci ON p.province_name = ci.province_name
        AND p.country_code = ci.country_code
WHERE p.area < 100000
    AND ci.population >= 10000
    AND ci.population <= 300000;

--QUERY 5: provinces with at least two diff cities with population
--         > 500000, in countries with inflation < 4.0. city is joined
--         to itself
SELECT DISTINCT c.country_code, c.country_name, c.inflation, p.province_name, p.area
FROM country c, province p, city ci1, city ci2
WHERE p.country_code = c.country_code
    AND ci1.province_name = p.province_name
    AND ci1.country_code = p.country_code
    AND ci2.province_name = p.province_name
    AND ci2.country_code = p.country_code
    AND ci1.city_name <> ci2.city_name
    AND ci1.population > 500000
    AND ci2.population > 500000
    AND c.inflation < 4.0;

--QUERY 6: q5 written with join syntax

SELECT DISTINCT c.country_code, c.country_name, c.inflation, p.province_name, p.area
FROM country c
    JOIN province p ON p.country_code = c.country_code
    JOIN city ci1 ON ci1.province_name = p.province_name
        AND ci1.country_code = p.country_code
    JOIN city ci2 ON ci2.province_name = p.province_name
        AND ci2.country_code = p.country_code
        AND ci1.city_name <> ci2.city_name
WHERE ci1.population > 500000
    AND ci2.population > 500000
    AND c.inflation < 4.0;


--QUERY 7: two city tables with the same name, diff populations and diff countries
SELECT c1.city_name AS city_name_1,
       c1.province_name AS province_name_1,
       c1.country_code AS country_code_1,
       c1.population AS population_1,
       c2.city_name AS city_name_2,
       c2.province_name AS province_name_2,
       c2.country_code AS country_code_2,
       c2.population AS population_2
FROM city c1 JOIN city c2 ON c1.city_name = c2.city_name
WHERE c1.country_code <> c2.country_code
  AND c1.population < c2.population;


--QUERY 8: countries that have a higher gdp and lower inflation rate compared to their border countries,
--         where the border length > 400.
SELECT DISTINCT c1.country_code, c1.country_name
FROM country c1, country c2, border b
WHERE ((b.country_code_1 = c1.country_code AND b.country_code_2 = c2.country_code)
    OR (b.country_code_2 = c1.country_code AND b.country_code_1 = c2.country_code))
  AND b.border_length > 400
  AND c1.gdp > c2.gdp
  AND c1.inflation < c2.inflation;

--QUERY 9: q8 written with join syntax
SELECT DISTINCT c1.country_code, c1.country_name
FROM border b
  JOIN country c1 ON c1.country_code = b.country_code_1
                  OR c1.country_code = b.country_code_2
  JOIN country c2 ON (c2.country_code = b.country_code_1
                   OR c2.country_code = b.country_code_2)
                 AND c2.country_code <> c1.country_code
WHERE b.border_length > 400
  AND c1.gdp > c2.gdp
  AND c1.inflation < c2.inflation;


--QUERY 10: provinces that have a city with over 1 million people, w/ a country w/ less than a 4.0 inflation rate
--          it returns the country name, province, name, and province area from biggest to smallest.
--          no duplicate rows as well. sorted by area so the largest regions are listed first
SELECT DISTINCT c.country_name, p.province_name, p.area
FROM country c
  JOIN province p ON c.country_code = p.country_code
  JOIN city ci ON p.province_name = ci.province_name
              AND p.country_code = ci.country_code
WHERE c.inflation < 4.0
  AND ci.population > 1000000
ORDER BY p.area DESC;
