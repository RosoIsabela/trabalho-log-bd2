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
            print(f"Transações que devem realizar REDO (IDs): {ids_committed}")
            return ids_committed
    except psycopg2.Error as erro:
        print(f"Erro ao buscar transações commitadas: {erro}")
        return []

def buscar_operacoes_por_transacao(conn, id_transacao):
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                select id_log, operacao, id_cliente, nome, saldo from log
                where id_transacao = %s and operacao in ('INSERT', 'UPDATE')
                order by id_log asc; 
            """, (id_transacao,))
            linhas = cursor.fetchall()
            operacoes = []
            for linha in linhas:
                operacoes.append({
                    "id_log": linha[0],
                    "tipo_operacao": linha[1],
                    "id_cliente": linha[2],
                    "nome": linha[3],
                    "saldo": linha[4]
                })
            return operacoes
    except psycopg2.Error as erro:
        print(f"Erro ao buscar operações da transação {id_transacao}: {erro}")
        return [] #Retorna lista vazia se der erro
