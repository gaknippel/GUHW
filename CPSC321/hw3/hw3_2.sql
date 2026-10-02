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

--QUERY 2: 
SELECT
FROM
WHERE