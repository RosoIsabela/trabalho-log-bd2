import psycopg2

def buscar_transacoes_commitadas(conn):
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                select id_transacao from log
                where operacao = 'COMMIT' and status_transacao = 'COMMITTED'
                order by id_transacao;
            """)

            ids_committed = [linha[0] for linha in cursor.fetchall()]
            print(f"Transações que devem realizar REDO(IDs): {ids_committed}")
            return ids_committed
    except psycopg2.Error as erro:
        print(f"Erro ao buscar transações commitadas: {erro}")
        return []