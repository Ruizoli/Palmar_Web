import os
import psycopg
from psycopg.rows import dict_row

DATABASE_URL = os.getenv("DATABASE_URL")


def get_connection():
    return psycopg.connect(DATABASE_URL, row_factory=dict_row)


def convertir_query(query):
    return query.replace("?", "%s")


def fetch_all(query, params=()):
    with get_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute(convertir_query(query), params)
            return cursor.fetchall()


def fetch_one(query, params=()):
    rows = fetch_all(query, params)
    return rows[0] if rows else None


def execute(query, params=()):
    with get_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute(convertir_query(query), params)
            conn.commit()


def execute_scalar(query, params=()):
    with get_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute(convertir_query(query), params)
            row = cursor.fetchone()
            if not row:
                return None
            return list(row.values())[0]