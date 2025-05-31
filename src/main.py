# Pacote adaptador do banco de dados
import psycopg2

from db import conectar_db
from logica_redo import buscar_transacoes_commitadas, buscar_operacoes_por_transacao
from executa_redo import executa_redo

def run_processo_redo(conn):
    print("Iniciando processo de REDO...")

    ids_transacoes_commitadas = buscar_transacoes_commitadas(conn)

    if not ids_transacoes_commitadas:
        print("Nenhuma transação commitada encontrada no log para REDO")
        return

    todas_operacoes_redo = []
    for tx_id in ids_transacoes_commitadas:
        print(f"\nBuscando operações para Transação ID: {tx_id}")
        operacoes_da_transacao = buscar_operacoes_por_transacao(conn, tx_id)
        if operacoes_da_transacao:
            todas_operacoes_redo.extend(operacoes_da_transacao)
        else:
            print(f"Nenhuma operação de dados (INSERT/UPDATE/DELETE) encontrada para a transação {tx_id}")

    if not todas_operacoes_redo:
        print("Nenhuma operação de dados (INSERT/UPDATE/DELETE) encontrada em todas as transações commitadas para aplicar REDO")
        return
    
    #Ordena todas as operacoes pelo id_log para manter a ordem correta
    todas_operacoes_redo.sort(key=lambda op: op['id_log'])

    print(f"\nTotal de {len(todas_operacoes_redo)} operações de dados a serem aplicadas via REDO")
    executa_redo(conn, todas_operacoes_redo)


def main():
    print("Aplicação de recuperação de log REDO iniciada")
    conn = None

    try:
        conn = conectar_db()
        if not conn:
            return
    
        run_processo_redo(conn) #funcao que executa o REDO

    except psycopg2.Erro as db_erro:
        print(f"Erro de banco de dados durante o REDO: {db_erro}")
        if conn:
            try:
                conn.rollback()
                print("Rollback da transação principal realizado devido a erro")
            except psycopg2.Erro as rb_erro:
                print(f"Erro durante o rollback: {rb_erro}")
    
    except Exception as e:
        print(f"Erro no processo principal: {e}")
    
    finally:
        if conn:
            conn.close()
            print("\nConexão com o banco de dados encerrada")

        print("Aplicação de Recuperação de log REDO finalizada")

if __name__ == "__main__":
    main()