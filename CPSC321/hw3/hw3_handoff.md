# HW3 Handoff — CPSC 321 (PostgreSQL)

## Context

I'm a CS student in CPSC 321 (databases, PostgreSQL).
I'm **dyslexic** — please explain with **short lines, small steps, simple words**, and tiny examples.

I finished HW3 (basic SQL queries) with help, but I want to actually **understand** it.
Teach me the concepts below **one at a time**, and quiz me after each one.

---

## My tables

```
country(country_code, country_name, gdp, inflation)
province(province_name, country_code, area)
city(city_name, province_name, country_code, population)
border(country_code_1, country_code_2, border_length)
```

- `province.country_code` → points to `country`
- `city (province_name, country_code)` → points to `province` (a **two-column** foreign key)
- each `border` code → points to `country`
- `border` has `CHECK (country_code_1 <> country_code_2)`
- a border can be stored as (A, B) **or** (B, A), but only one of them

---

## My data (short version)

**Countries**

| code | gdp | inflation |
|---|---|---|
| US | 46900 | 3.8 |
| CA | 43100 | 2.4 |
| MX | 15300 | 4.7 |
| DE | 52100 | 2.2 |

**Provinces**

- US: Washington, Oregon
- CA: Ontario, British Columbia
- MX: Jalisco, Sonora
- DE: Bavaria, Saxony

**Some cities**

- **Vancouver**: Washington (US, 190915) and British Columbia (CA, 662248)
- **Portland**: Oregon (US, 652503) and Ontario (CA, 15000)
- **Neustadt**: Bavaria (DE, 13000) and Saxony (DE, 12000)

**Borders**

- (MX, US, 3145)
- (US, CA, 8891)
- (CA, MX, 500)

---

## Concepts I want explained

1. **Comma join vs `JOIN ... ON`**
   - Why does a comma join need `WHERE c.country_code = p.country_code`?
   - (It pairs every row with every row. The `WHERE` keeps only the real matches.)
2. **Joining on two columns**
   - province → city uses both `province_name` and `country_code`.
3. **`DISTINCT`**
   - When and why it's needed.
   - Example: a province with several matching cities showing up more than once.
4. **Self-joins**
   - Using the same table twice (`city c1`, `city c2`).
5. **The `c1.population < c2.population` trick (Q7)**
   - removes equal populations
   - puts the smaller city first
   - stops each pair showing up twice
6. **Borders stored in either order (Q8/Q9)**
   - Why I need an `OR` with both directions.
   - Why the parentheses matter.
7. **`SELECT ... AS`** to rename columns.
8. **`ORDER BY` with `ASC` / `DESC`** on more than one column.

---

## My queries

Q2, Q4 and Q6 are just Q1, Q3 and Q5 rewritten with `JOIN ... ON` instead of commas.

### Q1 — comma join (area > 100000, gdp > 40000)

```sql
SELECT c.country_code, c.country_name, c.gdp, p.province_name, p.area
FROM country c, province p
WHERE c.country_code = p.country_code
  AND p.area > 100000
  AND c.gdp > 40000
ORDER BY c.gdp DESC, c.country_code ASC, p.area DESC;
```

### Q3 — comma join (area < 100000, a city with population 10000–300000)

```sql
SELECT DISTINCT p.country_code, p.province_name, p.area
FROM province p, city ci
WHERE p.province_name = ci.province_name
  AND p.country_code = ci.country_code
  AND p.area < 100000
  AND ci.population >= 10000
  AND ci.population <= 300000;
```

### Q5 — comma join (2+ different cities > 500000, inflation < 4.0)

```sql
SELECT DISTINCT c.country_code, c.country_name, c.inflation, p.province_name, p.area
FROM country c, province p, city ci1, city ci2
WHERE p.country_code = c.country_code
  AND ci1.province_name = p.province_name AND ci1.country_code = p.country_code
  AND ci2.province_name = p.province_name AND ci2.country_code = p.country_code
  AND ci1.city_name <> ci2.city_name
  AND ci1.population > 500000
  AND ci2.population > 500000
  AND c.inflation < 4.0;
```

### Q7 — self-join (same city name, different countries, smaller city first)

```sql
SELECT c1.city_name AS city_name_1, c1.province_name AS province_name_1,
       c1.country_code AS country_code_1, c1.population AS population_1,
       c2.city_name AS city_name_2, c2.province_name AS province_name_2,
       c2.country_code AS country_code_2, c2.population AS population_2
FROM city c1 JOIN city c2 ON c1.city_name = c2.city_name
WHERE c1.country_code <> c2.country_code
  AND c1.population < c2.population;
```

### Q8 — comma join (higher gdp AND lower inflation than a neighbor, border > 400)

```sql
SELECT DISTINCT c1.country_code, c1.country_name
FROM country c1, country c2, border b
WHERE ((b.country_code_1 = c1.country_code AND b.country_code_2 = c2.country_code)
    OR (b.country_code_2 = c1.country_code AND b.country_code_1 = c2.country_code))
  AND b.border_length > 400
  AND c1.gdp > c2.gdp
  AND c1.inflation < c2.inflation;
```

### Q9 — Q8 with JOIN syntax

```sql
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
```

### Q10 — my own (JOIN syntax, 3 tables)

Provinces with a city over 1 million, in countries with inflation < 4.0, biggest area first.

```sql
SELECT DISTINCT c.country_name, p.province_name, p.area
FROM country c
  JOIN province p ON c.country_code = p.country_code
  JOIN city ci ON p.province_name = ci.province_name
              AND p.country_code = ci.country_code
WHERE c.inflation < 4.0
  AND ci.population > 1000000
ORDER BY p.area DESC;
```

---

## Results I got

| Query | Result |
|---|---|
| Q1 / Q2 | Oregon, Washington, Ontario, BC |
| Q3 / Q4 | Bavaria, Saxony |
| Q5 / Q6 | Ontario, Bavaria, Saxony |
| Q7 | the Vancouver pair and the Portland pair |
| Q8 / Q9 | US, Canada |
| Q10 | Ontario, then Bavaria |

---

## Questions I still have

- Why did my first try at Q9 (joining `c1` only on `country_code_1`) miss the US?
- In Q5, how does using `city` twice check for "at least 2 cities"?
