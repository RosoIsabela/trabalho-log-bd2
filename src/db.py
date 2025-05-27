import psycopg2

DB_CONFIG = {
    "dbname": "trabalho-bd2",
    "user": "postgres",
    "password": "postgre",
    "host": "localhost",
    "port": "5432"
}

def conectar_db():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        print("Conectado ao banco de dados com sucesso")
        return conn
    except psycopg2.Error as erro:
        print(f"Erro ao conectar ao banco de dados: {erro}")
        return None