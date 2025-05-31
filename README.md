#  Trabalho de Implementação de Log REDO com PostgreSQL e Python 📄🔁

Este projeto demonstra a implementação de um mecanismo de log REDO utilizando PostgreSQL como Sistema Gerenciador de Banco de Dados (SGBD) e Python para o processamento do log e recuperação de dados. O objetivo é simular operações em uma tabela, registrar essas operações em um log persistente e, após uma "queda" simulada do sistema (onde dados não commitados são perdidos), usar o log para restaurar o estado das transações que foram efetivamente concluídas (commitadas).

## 🎯 Objetivo Principal

Implementar e entender o funcionamento do mecanismo de log REDO, um conceito fundamental em sistemas de banco de dados para garantir a durabilidade e a capacidade de recuperação após falhas.

## ⚙️ Como Funciona

1.  Uma tabela especial `clientes_em_memoria` é criada como `UNLOGGED TABLE`. Isso significa que suas alterações não são escritas no Write-Ahead Log (WAL) do PostgreSQL, fazendo com que seus dados sejam perdidos em caso de uma queda do SGBD, o que é ideal para a simulação.
2.  Uma tabela normal e persistente chamada `log` é criada para armazenar o registro de todas as operações (como `INSERT`, `UPDATE`) realizadas na tabela `clientes_em_memoria`, bem como os marcadores de `COMMIT` das transações.
3.  Gatilhos (triggers) e funções SQL são utilizados para popular automaticamente a tabela `log` sempre que ocorrem modificações em `clientes_em_memoria` ou quando uma transação é explicitamente marcada como comitada.
4.  Após a execução de um conjunto de transações (algumas comitadas, outras não), o SGBD é "derrubado" (serviço parado) e reiniciado para simular uma falha. 
5.  Um script Python é executado para ler a tabela `log` (que sobreviveu à queda). 
6.  O script Python identifica as transações que foram comitadas e reaplica suas operações (REDO) na tabela `clientes_em_memoria`.

## 🛠️ Tecnologias Utilizadas

* **Banco de Dados:** PostgreSQL
* **Linguagem de Programação (REDO):** Python 3
* **Adaptador PostgreSQL para Python:** `psycopg2` 

## 📁 Estrutura do Projeto
trabalho-bd2/<br>
├── sql/<br>
│   ├── create_tables.sql<br>
│   ├── popular_tables.sql<br>
│   └── triggers.sql<br>
├── src/<br>
│   ├── init.py<br>
│   ├── db.py<br>
│   ├── logica_redo.py<br>
│   ├── executa_redo.py<br>
│   └── main.py<br>
└── README.md