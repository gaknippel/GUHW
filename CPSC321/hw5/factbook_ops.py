"""Database functions for the CIA World Factbook tables.

Author: Greyson Knippel
Course: CPSC 321
Date: Fall 2026

Description: The following functions execute various SQL statements over
the factbook tables using the given connection or cursor.
"""

import psycopg as pg


def list_countries(cur: pg.Cursor) -> None:
    """Selects the code, name, gdp, and inflation of every country,
    sorted by name followed by country code. The calling function
    obtains results through the cursor.
    """
    q = """
        SELECT country_code, country_name, gdp, inflation
          FROM country
         ORDER BY country_name, country_code;
    """
    cur.execute(q)


def get_country(cn: pg.Connection, code: str) -> tuple | None:
    """Returns the code, name, gdp, and inflation of the given
    country, or None if no country has the given code.
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
    """Inserts the given country in the database. Returns True if the
    country is inserted, or False if its code already exists.
    """
    raise NotImplementedError("Not implemented yet")


def update_country(cn: pg.Connection, code: str,
                   gdp: int, inflation: float) -> bool:
    """Sets the given country's gdp and inflation. Returns True if the
    country exists, including when its values are unchanged, and False
    if no country has the given code.
    """
    raise NotImplementedError("Not implemented yet")


def remove_border(cn: pg.Connection, code1: str, code2: str) -> bool:
    """Deletes the border between the given countries. The codes may
    be given in either order. Returns True if the border is deleted,
    or False if there is no such border.
    """
    raise NotImplementedError("Not implemented yet")


def add_province_with_city(cn: pg.Connection, country_code: str,
                           province_name: str, area: float,
                           city_name: str, population: int) -> bool:
    """Inserts the given province followed by the province's city into
    the database. Returns True if both are inserted. If the province
    already exists in the given country, returns False without
    inserting the city.
    """
    raise NotImplementedError("Not implemented yet")


def find_cities(cur: pg.Cursor,
                country_code: str | None = None,
                province_name: str | None = None,
                min_population: int | None = None,
                max_population: int | None = None) -> None:
    """Selects the name, province, country code, and population of
    each city that matches all supplied filters. A filter that is None
    is not used. Population bounds are inclusive. The calling function
    obtains results through the cursor.
    """
    raise NotImplementedError("Not implemented yet")
