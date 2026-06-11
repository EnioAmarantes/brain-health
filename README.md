# Brain Health

Projeto focado em MVP para triagem com IA e encaminhamento para profissionais.

## Estrutura Atual

```
brain-health/
├── backend/                 # API .NET 8
├── frontend-web/            # Angular
├── docker-compose.yml       # Orquestra API + Frontend + MariaDB
├── docker-compose.staging.yml
├── docker-compose.production.yml
├── legacy/                  # Scripts e service antigos (systemd)
├── archive/                 # Historico preservado
├── MVP_EXECUTION_PLAN.md    # Direcionamento do MVP
└── README.md
```

## Versionamento da Raiz

- A raiz agora e um repositorio Git proprio para infraestrutura e operacao.
- `backend/` e `frontend-web/` foram adicionados como submodulos.
- Ter repositorios dentro da raiz nao e problema quando isso e intencional e controlado por submodulos.
- Beneficio: rastreabilidade completa do estado da operacao + versao exata de backend/frontend em cada commit da raiz.

Comandos uteis:

```bash
git submodule status
git submodule update --init --recursive
```

## Subir com Docker

Pre-requisito: Docker e Docker Compose.

1. Opcional: exportar a chave da OpenAI

```bash
export OPENAI_API_KEY="sua_chave"
```

2. Subir stack completa

```bash
docker compose up -d --build
```

3. URLs

- Frontend: http://localhost:8080
- API: http://localhost:5000
- Swagger: http://localhost:5000/swagger
- MariaDB: localhost:3326

4. Parar stack

```bash
docker compose down
```

5. Parar e remover volume do banco

```bash
docker compose down -v
```

## Ambientes

- Staging: usar `docker-compose.yml` + `docker-compose.staging.yml`
- Producao: usar `docker-compose.yml` + `docker-compose.production.yml`

Arquivos de exemplo:

- `.env.staging.example`
- `.env.production.example`

Exemplo de subida em staging:

```bash
cp .env.staging.example .env.staging
docker compose --env-file .env.staging -f docker-compose.yml -f docker-compose.staging.yml up -d --build
```

Exemplo de subida em producao:

```bash
cp .env.production.example .env.production
docker compose --env-file .env.production -f docker-compose.yml -f docker-compose.production.yml up -d --build
```

## GitHub Actions (CI/CD)

Workflows criados:

- `.github/workflows/ci.yml`
- `.github/workflows/deploy-staging.yml`
- `.github/workflows/deploy-production.yml`

### Segredos obrigatorios (Repository Secrets)

Staging:

- `STAGING_SSH_HOST`
- `STAGING_SSH_USER`
- `STAGING_SSH_KEY`
- `STAGING_SSH_PORT`
- `STAGING_DB_ROOT_PASSWORD`
- `OPENAI_API_KEY_STAGING`

Producao:

- `PROD_SSH_HOST`
- `PROD_SSH_USER`
- `PROD_SSH_KEY`
- `PROD_SSH_PORT`
- `PROD_DB_ROOT_PASSWORD`
- `OPENAI_API_KEY_PROD`

Comum:

- `GHCR_PAT` (token com permissao de leitura no GHCR para o servidor fazer pull)

### Variaveis de ambiente do GitHub (Repository/Environment Variables)

- `STAGING_DEPLOY_PATH` (ex.: `/opt/brain-health/staging`)
- `PROD_DEPLOY_PATH` (ex.: `/opt/brain-health/production`)

## Observacoes

- Arquivos de systemd e scripts antigos foram movidos para `legacy/`.
- Historico de textos foi movido para `archive/history/txt/`.
- A abordagem oficial do projeto agora e Docker-first para ambiente local e deploy.
