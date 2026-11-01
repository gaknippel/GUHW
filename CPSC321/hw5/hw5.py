"""Menu program for the CIA World Factbook database.

Author: Greyson Knippel
Course: CPSC 321
Date: Fall 2026

Description: A text menu over the factbook database.

Usage:
  python hw5.py
"""

import psycopg as pg

import factbook_ops as ops
from db_config import DB_CONFIG

MENU = """
1. List countries
2. Show country
3. Add country
4. Update country
5. Remove border
6. Add province with city
7. Search cities
8. Exit"""


def list_countries_action() -> None:
    """Displays each country, one country per line."""
    with pg.connect(**DB_CONFIG) as cn:
        with cn.cursor() as cur:
            ops.list_countries(cur)
            for code, name, gdp, inflation in cur:
                print(f'{name} ({code}), per capita gdp ${gdp}, '
                      f'inflation rate {inflation}%')


def show_country_action() -> None:
    """displays the country with the code the user enters, in the same
    format as list_countries_action, or a message if there is no such
    country
    """
    code = input('Country code: ').strip()
    with pg.connect(**DB_CONFIG) as cn:
        row = ops.get_country(cn, code)
    print()
    if row is None:
        print('No matching country.')
    else:
        code, name, gdp, inflation = row
        print(f'{name} ({code}), per capita gdp ${gdp}, '
              f'inflation rate {inflation}%')


def add_country_action() -> None:
    """adds the country the user enters. Displays whether the country
    was added or already exists
    """
    code = input('Country code: ').strip()
    name = input('Country name: ').strip()
    gdp = int(input('Country gdp: '))
    inflation = float(input('Country inflation: '))
    with pg.connect(**DB_CONFIG) as cn:
        added = ops.add_country(cn, code, name, gdp, inflation)
    print()
    if added:
        print('Country added.')
    else:
        print('Country already exists.')


def update_country_action() -> None:
    """sets the gdp and inflation of the country the user enters.
    displays whether the country was updated or does not exist
    """
    code = input('Country code: ').strip()
    gdp = int(input('Country gdp: '))
    inflation = float(input('Country inflation: '))
    with pg.connect(**DB_CONFIG) as cn:
        updated = ops.update_country(cn, code, gdp, inflation)
    print()
    if updated:
        print('Country updated.')
    else:
        print('Country does not exist.')


def remove_border_action() -> None:
    """removes the border between the two countries the user enters.
    displays whether the border was removed or does not exist
    """
    code1 = input('Country 1 code: ').strip()
    code2 = input('Country 2 code: ').strip()
    with pg.connect(**DB_CONFIG) as cn:
        removed = ops.remove_border(cn, code1, code2)
    print()
    if removed:
        print('Border removed.')
    else:
        print('No border exists between the countries.')


def add_province_with_city_action() -> None:
    """adds the province and city the user enters. displays whether
    both were added or the province already exists
    """
    country_code = input('Country code: ').strip()
    province_name = input('Province name: ').strip()
    area = float(input('Province area: '))
    city_name = input('City name: ').strip()
    population = int(input('City population: '))
    with pg.connect(**DB_CONFIG) as cn:
        added = ops.add_province_with_city(cn, country_code, province_name,
                                           area, city_name, population)
    print()
    if added:
        print('Province and city added.')
    else:
        print('Province already exists.')


def search_cities_action() -> None:
    """displays the cities that match the filters the user enters, one
    city per line, 5 cities at a time. After each 5, asks the user
    whether to see more
    """
    country_code = input('Country code (enter to skip): ').strip() or None
    province_name = input('Province name (enter to skip): ').strip() or None
    min_pop = input('Minimum population (enter to skip): ').strip()
    max_pop = input('Maximum population (enter to skip): ').strip()
    min_pop = int(min_pop) if min_pop else None
    max_pop = int(max_pop) if max_pop else None
    with pg.connect(**DB_CONFIG) as cn:
        with cn.cursor(name='city_search') as cur:
            ops.find_cities(cur, country_code, province_name,
                            min_pop, max_pop)
            rows = cur.fetchmany(5)
            print()
            if not rows:
                print('No matching cities.')
            while rows:
                for name, province, code, population in rows:
                    print(f'{name}, {province} ({code}), '
                          f'population {population}')
                print()
                if input('See more rows (y/n): ').strip() != 'y':
                    break
                print()
                rows = cur.fetchmany(5)


ACTIONS = {
    '1': list_countries_action,
    '2': show_country_action,
    '3': add_country_action,
    '4': update_country_action,
    '5': remove_border_action,
    '6': add_province_with_city_action,
    '7': search_cities_action,
}


def main() -> None:
    """displays the menu and runs the chosen action until exit."""
    while True:
        print(MENU)
        choice = input('Enter your choice (1-8): ').strip()
        if choice == '8':
            break
        print()
        action = ACTIONS.get(choice)
        if action is None:
            print('Invalid choice.')
        else:
            try:
                action()
            except pg.Error as e:
                print(f'Database error: {e}')


if __name__ == '__main__':
    main()
