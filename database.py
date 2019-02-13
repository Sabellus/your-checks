import psycopg2

CONFIG = {
    'user': 'postgres',
    'password': '',
    'database': 'checks',
    'host': 'localhost',
    'port': '5432',
}

def create_connection():
    conn = psycopg2.connect(**CONFIG)
    return conn