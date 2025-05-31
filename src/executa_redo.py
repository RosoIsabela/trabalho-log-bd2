import psycopg2 # Para psycopg2.Error

def executa_redo(conn, operacoes):
    print("\n- Iniciando aplicação das operações de REDO -")
    for op in operacoes:
        print(f"Processando id_log: {op['id_log']}, Operação: {op['tipo_operacao']}, Cliente id: {op['id_cliente']}")
        try:
            with conn.cursor() as cursor:
                if op["tipo_operacao"] == "INSERT":
                    cursor.execute("""
                            insert into clientes_em_memoria (id, nome, saldo)
                            values (%s, %s, %s);
                        """, (op['id_cliente'], op['nome'], op['saldo']))
                elif op["tipo_operacao"] == "UPDATE":
                    cursor.execute("""
                            update clientes_em_memoria 
                            set nome = %s, saldo = %s
                            where id = %s;
                        """, (op['nome'], op['saldo'], op['id_cliente']))
                elif op["tipo_operacao"] == "DELETE":
                    cursor.execute("""
                            delete from clientes_em_memoria 
                            where id = %s 
                        """, (op['id_cliente'],))
            conn.commit()
        except psycopg2.Error as erro:
            print(f"Erro ao aplicar operação (id_log {op['id_log']}): {erro}")
            conn.rollback()
