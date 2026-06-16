# PostgreSQL + pgAdmin com Docker 🐘

Ambiente local com PostgreSQL e pgAdmin usando Docker Compose. Ele já vem preparado para estudos de SQL com scripts de inicialização em `.docker/initdb`, incluindo schema e seed executados automaticamente no primeiro start do banco.

## ✅ Pré-requisitos

- Docker instalado
- Docker Compose disponível pelo comando `docker compose`
- Um cliente PostgreSQL opcional, como DBeaver, DataGrip, Beekeeper Studio, TablePlus ou similar

## ⚙️ Configurando o `.env`

Crie seu arquivo `.env` a partir do `.env.example`.

No Windows PowerShell:

```powershell
copy .env.example .env
```

No Linux, macOS ou Git Bash:

```bash
cp .env.example .env
```

O arquivo `.env.example` já vem com uma configuração pronta para uso:

```env
TZ=America/Sao_Paulo

POSTGRES_USER=root
POSTGRES_PASSWORD=mypass
POSTGRES_DB=test_db
POSTGRES_PORT=7711
POSTGRES_VERSION=17-alpine

PGADMIN_DEFAULT_EMAIL=root@email.com
PGADMIN_DEFAULT_PASSWORD=mypass
PGADMIN_PORT=2563
PGADMIN_VERSION=9.15.0
```

Principais variáveis:

- `POSTGRES_USER`: usuário do banco PostgreSQL
- `POSTGRES_PASSWORD`: senha do banco PostgreSQL
- `POSTGRES_DB`: banco criado automaticamente no primeiro start
- `POSTGRES_PORT`: porta exposta na sua máquina
- `PGADMIN_DEFAULT_EMAIL`: email para login no pgAdmin
- `PGADMIN_DEFAULT_PASSWORD`: senha para login no pgAdmin
- `PGADMIN_PORT`: porta do pgAdmin no navegador

## 🚀 Rodando o ambiente

Suba os containers em segundo plano:

```bash
docker compose up -d
```

Verifique os containers:

```bash
docker compose ps
```

Pare o ambiente sem apagar os dados:

```bash
docker compose down
```

Pare o ambiente e apague os volumes do banco e do pgAdmin:

```bash
docker compose down -v
```

> ⚠️ Use `docker compose down -v` quando quiser reiniciar o PostgreSQL do zero e executar novamente os scripts de seed.

## 🌐 Acessando o pgAdmin

Depois que os containers estiverem rodando, acesse:

```text
http://localhost:2563
```

Login padrão:

```text
Email: root@email.com
Senha: mypass
```

Para registrar o servidor PostgreSQL dentro do pgAdmin:

1. Clique em `Add New Server`
2. Em `General`, escolha um nome, por exemplo `Local PostgreSQL`
3. Em `Connection`, use:

```text
Host name/address: db
Port: 5432
Maintenance database: test_db
Username: root
Password: mypass
```

> 💡 Dentro da rede Docker, o pgAdmin acessa o PostgreSQL pelo nome do serviço: `db`.

## 🧩 Conectando pelo DBeaver e outros clientes

Você também pode acessar o banco usando DBeaver, DataGrip, Beekeeper Studio, TablePlus ou qualquer outro programa compatível com PostgreSQL.

Use estes dados de conexão:

```text
Host: localhost
Porta: 7711
Database: test_db
Usuário: root
Senha: mypass
```

> 💡 Fora do Docker, use `localhost` e a porta exposta no `.env`: `POSTGRES_PORT=7711`.

## 🌱 Scripts de inicialização

Os scripts SQL ficam em:

```text
.docker/initdb
```

Essa pasta é montada no container em:

```text
/docker-entrypoint-initdb.d
```

O PostgreSQL executa esses arquivos automaticamente apenas na primeira inicialização do volume de dados.

Arquivos atuais:

- `01_schema.sql`: cria a estrutura do banco
- `02_seed.sql`: popula dados iniciais para praticar consultas

Se você editar esses arquivos depois que o banco já foi criado, eles não serão executados novamente automaticamente. Para recriar tudo do zero:

```bash
docker compose down -v
docker compose up -d
```

## 🧠 Ideias para praticar SQL

Com a seed atual, você pode praticar:

- `JOIN` entre alunos, cursos, professores e departamentos
- `WHERE` para filtros por semestre, departamento ou nota
- `GROUP BY` e `HAVING` para agregações
- `COUNT`, `AVG`, `MIN`, `MAX` e `SUM`
- subconsultas com pré-requisitos de cursos
- relatórios de turmas, salas e orientadores
