CREATE UNLOGGED TABLE clientes_em_memoria (
    id SERIAL PRIMARY KEY,
    nome TEXT,
    saldo NUMERIC
);


CREATE TABLE log (
    id_log SERIAL PRIMARY KEY,
    id_transacao INT,
    operacao TEXT,
    id_cliente INT NULL,
    nome TEXT NULL,           
    saldo NUMERIC NULL,
    status_transacao TEXT
);