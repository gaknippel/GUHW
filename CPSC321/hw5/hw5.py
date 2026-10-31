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
    """Displays the country with the code the user enters, in the same
    format as list_countries_action, or a message if there is no such
    country.
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
    """Adds the country the user enters. Displays whether the country
    was added or already exists.
    """
    print("Not implemented yet.")


def update_country_action() -> None:
    """Sets the gdp and inflation of the country the user enters.
    Displays whether the country was updated or does not exist.
    """
    print("Not implemented yet.")


def remove_border_action() -> None:
    """Removes the border between the two countries the user enters.
    Displays whether the border was removed or does not exist.
    """
    print("Not implemented yet.")


def add_province_with_city_action() -> None:
    """Adds the province and city the user enters. Displays whether
    both were added or the province already exists.
    """
    print("Not implemented yet.")


def search_cities_action() -> None:
    """Displays the cities that match the filters the user enters, one
    city per line, 5 cities at a time. After each 5, asks the user
    whether to see more.
    """
    # Hint: use a named cursor for this search.
    print("Not implemented yet.")


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
    """Displays the menu and runs the chosen action until Exit."""
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
