-- Função que insere no log quando houver INSERT ou UPDATE ou DELETE
CREATE OR REPLACE FUNCTION log_operacoes_clientes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO log (id_transacao, operacao, id_cliente, nome, saldo, status_transacao)
        VALUES (
            txid_current(),
            TG_OP,
            OLD.id,
            OLD.nome,
            OLD.saldo,
            NULL
        );
        RETURN OLD;
    ELSE
        INSERT INTO log (id_transacao, operacao, id_cliente, nome, saldo, status_transacao)
        VALUES (
            txid_current(),
            TG_OP,
            NEW.id,
            NEW.nome,
            NEW.saldo,
            NULL
        );
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_log_operacoes
AFTER INSERT OR UPDATE OR DELETE ON clientes_em_memoria
FOR EACH ROW
EXECUTE FUNCTION log_operacoes_clientes();

-- Função que registra commit
CREATE OR REPLACE FUNCTION registrar_commit()
RETURNS VOID AS $$
BEGIN
    INSERT INTO log (id_transacao, operacao, status_transacao)
    VALUES (txid_current(), 'COMMIT', 'COMMITTED');
END;
$$ LANGUAGE plpgsql;