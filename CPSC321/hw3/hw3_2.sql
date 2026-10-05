/*============================================================
 * NAME: GREYSON KNIPPEL
 * ASSIGN: HW-3, Part 2
 * COURSE: CPSC 321, Fall 2026
 * DESC: 
 *============================================================*/

--PART 2--

 --QUERY 1: area & gdp greater than in country and province.
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

--QUERY 3: comma join where you filter province area, city population range, and country code with custom numbers and ranges.
SELECT DISTINCT p.country_code, p.province_name, p.area
FROM province p, city ci
WHERE p.province_name = ci.province_name
    AND p.country_code = ci.country_code
    AND p.area < 40000
    AND ci.population >= 50000
    AND ci.population <= 500000;

--QUERY 4: q3 written with join syntax
SELECT DISTINCT p.country_code, p.province_name, p.area
FROM province p
    JOIN city ci ON p.province_name = ci.province_name
        AND p.country_code = ci.country_code
WHERE p.area < 40000
    AND ci.population >= 50000
    AND ci.population <= 500000;

--QUERY 5: provinces with at least two diff cities with population
--         > 100000, in countries with inflation < 5.0. city is joined
--         to itself
SELECT DISTINCT c.country_code, c.country_name, c.inflation, p.province_name, p.area
FROM country c, province p, city ci1, city ci2
WHERE p.country_code = c.country_code
    AND ci1.province_name = p.province_name
    AND ci1.country_code = p.country_code
    AND ci2.province_name = p.province_name
    AND ci2.country_code = p.country_code
    AND ci1.city_name <> ci2.city_name
    AND ci1.population > 100000
    AND ci2.population > 100000
    AND c.inflation < 5.0;

--QUERY 6: q5 written with join syntax

SELECT DISTINCT c.country_code, c.country_name, c.inflation, p.province_name, p.area
FROM country c
    JOIN province p ON p.country_code = c.country_code
    JOIN city ci1 ON ci1.province_name = p.province_name
        AND ci1.country_code = p.country_code
    JOIN city ci2 ON ci2.province_name = p.province_name
        AND ci2.country_code = p.country_code
        AND ci1.city_name <> ci2.city_name
WHERE ci1.population > 100000
    AND ci2.population > 100000
    AND c.inflation < 5.0;