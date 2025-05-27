-- Transação 1
BEGIN;

INSERT INTO clientes_em_memoria (nome, saldo) 
VALUES ('Cliente 1', 100.00);

INSERT INTO log (id_transacao, operacao, id_cliente, nome, saldo, status_transacao)
VALUES (1, 'INSERT', 1, 'Cliente 1', 100.00, NULL);

UPDATE clientes_em_memoria SET saldo = saldo + 50 WHERE id = 1;

INSERT INTO log (id_transacao, operacao, id_cliente, nome, saldo, status_transacao)
VALUES (1, 'UPDATE', 1, 'Cliente 1', 150.00, NULL);

END;

-- Marcando a Transação 1 como COMMITTED no log
INSERT INTO log (id_transacao, operacao, status_transacao)
VALUES (1, 'COMMIT', 'COMMITTED');


-- Transação 2 
BEGIN;

INSERT INTO clientes_em_memoria (nome, saldo) 
VALUES ('Cliente 2', 200.00);

INSERT INTO log (id_transacao, operacao, id_cliente, nome, saldo, status_transacao)
VALUES (2, 'INSERT', 2, 'Cliente 2', 200.00, NULL);

UPDATE clientes_em_memoria SET saldo = saldo + 50 WHERE id = 2;

INSERT INTO log (id_transacao, operacao, id_cliente, nome, saldo, status_transacao)
VALUES (2, 'UPDATE', 2, 'Cliente 2', 250.00, NULL);

END;

-- Marcando a Transação 2 como COMMITTED no log
INSERT INTO log (id_transacao, operacao, status_transacao)
VALUES (2, 'COMMIT', 'COMMITTED');


-- Transação 3
BEGIN;

INSERT INTO clientes_em_memoria (nome, saldo) 
VALUES ('Cliente 3', 300.00);

INSERT INTO log (id_transacao, operacao, id_cliente, nome, saldo, status_transacao)
VALUES (3, 'INSERT', 3, 'Cliente 3', 300.00, NULL);

-- Atualiza o cliente 2
UPDATE clientes_em_memoria SET saldo = saldo + 50 WHERE id = 2;

INSERT INTO log (id_transacao, operacao, id_cliente, nome, saldo, status_transacao)
VALUES (3, 'UPDATE', 2, 'Cliente 2', 300.00, NULL);

END;

-- Marcando a Transação 3 como COMMITTED no log
INSERT INTO log (id_transacao, operacao, status_transacao)
VALUES (3, 'COMMIT', 'COMMITTED');


-- Transação 4
BEGIN;

INSERT INTO clientes_em_memoria (nome, saldo) 
VALUES ('Cliente 4', 400.00);

INSERT INTO log (id_transacao, operacao, id_cliente, nome, saldo, status_transacao)
VALUES (4, 'INSERT', 4, 'Cliente 4', 400.00, NULL);

-- Atualiza o cliente 3
UPDATE clientes_em_memoria SET saldo = saldo + 50 WHERE id = 3;

INSERT INTO log (id_transacao, operacao, id_cliente, nome, saldo, status_transacao)
VALUES (4, 'UPDATE', 3, 'Cliente 3', 350.00, NULL);

END;

-- Marcando a Transação 4 como COMMITTED no log
INSERT INTO log (id_transacao, operacao, status_transacao)
VALUES (4, 'COMMIT', 'COMMITTED'); 


-- Transação 5
BEGIN;

INSERT INTO clientes_em_memoria (nome, saldo) 

VALUES ('Cliente 6', 600.00);
INSERT INTO log (id_transacao, operacao, id_cliente, nome, saldo, status_transacao)
VALUES (5, 'INSERT', 5, 'Cliente 6', 600.00, NULL);

-- não tem 'END;', logo não deve ter registro de commit no log para a transação 5
-- Isso simula uma transação que estava em progresso quando o sistema caiu
-- O REDO deverá ignorar esta transação.
