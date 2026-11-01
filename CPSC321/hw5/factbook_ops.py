"""Database functions for the CIA World Factbook tables.

Author: Greyson Knippel
Course: CPSC 321
Date: Fall 2026

Description: The following functions execute various SQL statements over
the factbook tables using the given connection or cursor.
"""

import psycopg as pg


def list_countries(cur: pg.Cursor) -> None:
    """selects the code, name, gdp, and inflation of every country,
    sorted by name followed by country code. the calling function
    obtains results through the cursor
    """
    q = """
        SELECT country_code, country_name, gdp, inflation
          FROM country
         ORDER BY country_name, country_code;
    """
    cur.execute(q)


def get_country(cn: pg.Connection, code: str) -> tuple | None:
    """returns the code, name, gdp, and inflation of the given
    country, or none if no country has the given code
    """
    q = """
        SELECT country_code, country_name, gdp, inflation
          FROM country
         WHERE country_code = %s;
    """
    with cn.cursor() as cur:
        cur.execute(q, (code,))
        return cur.fetchone()


def add_country(cn: pg.Connection, code: str, name: str,
                gdp: int, inflation: float) -> bool:
    """inserts the given country in the database. returns true if the
    country is inserted, or false if its code already exists
    """
    q1 = """
        SELECT country_code
          FROM country
         WHERE country_code = %s;
    """
    q2 = """
        INSERT INTO country (country_code, country_name, gdp, inflation)
        VALUES (%s, %s, %s, %s);
    """
    with cn.cursor() as cur:
        cur.execute(q1, (code,))
        if cur.fetchone() is not None:
            return False
        cur.execute(q2, (code, name, gdp, inflation))
        return True


def update_country(cn: pg.Connection, code: str,
                   gdp: int, inflation: float) -> bool:
    """sets the given country's gdp and inflation. returns true if the
    country exists, including when its values are unchanged, and false
    if no country has the given code
    """
    q = """
        UPDATE country
           SET gdp = %s, inflation = %s
         WHERE country_code = %s;
    """
    with cn.cursor() as cur:
        cur.execute(q, (gdp, inflation, code))
        return cur.rowcount > 0


def remove_border(cn: pg.Connection, code1: str, code2: str) -> bool:
    """deletes the border between the given countries. the codes may
    be given in either order. returns true if the border is deleted,
    or false if there is no such border
    """
    q = """
        DELETE FROM border
         WHERE (country_code_1 = %s AND country_code_2 = %s)
            OR (country_code_1 = %s AND country_code_2 = %s);
    """
    with cn.cursor() as cur:
        cur.execute(q, (code1, code2, code2, code1))
        return cur.rowcount > 0


def add_province_with_city(cn: pg.Connection, country_code: str,
                           province_name: str, area: float,
                           city_name: str, population: int) -> bool:
    """inserts the given province followed by the province's city into
    the database. returns true if both are inserted. if the province
    already exists in the given country, returns false without
    inserting the city
    """
    q1 = """
        SELECT province_name
          FROM province
         WHERE province_name = %s AND country_code = %s;
    """
    q2 = """
        INSERT INTO province (province_name, country_code, area)
        VALUES (%s, %s, %s);
    """
    q3 = """
        INSERT INTO city (city_name, province_name, country_code, population)
        VALUES (%s, %s, %s, %s);
    """
    with cn.cursor() as cur:
        cur.execute(q1, (province_name, country_code))
        if cur.fetchone() is not None:
            return False
        cur.execute(q2, (province_name, country_code, area))
        cur.execute(q3, (city_name, province_name, country_code, population))
        return True


def find_cities(cur: pg.Cursor,
                country_code: str | None = None,
                province_name: str | None = None,
                min_population: int | None = None,
                max_population: int | None = None) -> None:
    """selects the name, province, country code, and population of
    each city that matches all supplied filters. a filter that is none
    is not used. population bounds are inclusive. the calling function
    obtains results through the cursor
    """
    q = """
        SELECT city_name, province_name, country_code, population
          FROM city
    """
    filters = []
    params = []
    if country_code is not None:
        filters.append('country_code = %s')
        params.append(country_code)
    if province_name is not None:
        filters.append('province_name = %s')
        params.append(province_name)
    if min_population is not None:
        filters.append('population >= %s')
        params.append(min_population)
    if max_population is not None:
        filters.append('population <= %s')
        params.append(max_population)
    if filters:
        q += ' WHERE ' + ' AND '.join(filters)
    q += ' ORDER BY population DESC, country_code, province_name, city_name'
    cur.execute(q, params)
