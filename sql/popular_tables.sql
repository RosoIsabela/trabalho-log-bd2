-- Transação 1
BEGIN;
    INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Cliente 1', 100.00);
    UPDATE clientes_em_memoria SET saldo = saldo + 50 WHERE id = 1;
    SELECT registrar_commit(); 
END;

-- Transação 2
BEGIN;
    INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Cliente 2', 200.00);
    UPDATE clientes_em_memoria SET saldo = saldo + 50 WHERE id = 2;
    SELECT registrar_commit(); 
END;


-- Transação 3
BEGIN;
	INSERT INTO clientes_em_memoria (nome, saldo) VALUES ('Cliente 3', 300.00);
	-- Atualiza o cliente 2
	UPDATE clientes_em_memoria SET saldo = saldo + 50 WHERE id = 2;
	SELECT registrar_commit(); -- Marcando a Transação 3 como COMMITTED no log
END;


-- Transação 4
BEGIN;

INSERT INTO clientes_em_memoria (nome, saldo) 
VALUES ('Cliente 4', 400.00);

-- Atualiza o cliente 3
UPDATE clientes_em_memoria SET saldo = saldo + 50 WHERE id = 3;


-- Transação 5
BEGIN;

INSERT INTO clientes_em_memoria (nome, saldo) 
VALUES ('Cliente 6', 600.00);

-- não tem 'END;', logo não deve ter registro de commit no log para a transação 5
-- Isso simula uma transação que estava em progresso quando o sistema caiu
-- O REDO deverá ignorar esta transação.
