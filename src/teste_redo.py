from db import conectar_db
from logica_redo import buscar_transacoes_commitadas


if __name__ == "__main__":
    conn = conectar_db()
    if conn:
        buscar_transacoes_commitadas(conn)
        conn.close()