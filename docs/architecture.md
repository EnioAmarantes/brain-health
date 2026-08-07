# Arquitetura

## Visão Geral

O projeto segue separação por camadas no backend (Clean Architecture + DDD) e organização por feature no frontend.

- Backend: API .NET 10 com EF Core e MariaDB.
- Frontend: Angular 18 para fluxo de triagem e resultado.
- Orquestração local: Docker Compose (API, Frontend, MariaDB e Grafana).

---

## Backend

### Tecnologias

- .NET 10
- Entity Framework Core
- MariaDB
- FluentValidation

### Organização por projetos

- `BrainHealth.API` (Presentation): controllers e configuração da aplicação.
- `BrainHealth.Core` (Domain + Contracts): entidades, DTOs, interfaces e regras de domínio.
- `BrainHealth.Infrastructure` (Infrastructure + Application Services): serviços de aplicação, persistência e integrações externas.

### Camadas e responsabilidades

#### Presentation (`BrainHealth.API`)

- Expor endpoints HTTP.
- Validar contrato de entrada.
- Delegar orquestração para serviços.

Não deve conter regra de negócio nem acesso direto ao banco.

#### Core (`BrainHealth.Core`)

- Entidades: `Questionnaire`, `Lead`, `TriageAssessment`, `Professional`.
- Contratos: `IQuestionnaireService`, `IAIAnalysisService`, `IQuestionnaireRepository`.
- Regras de pontuação e validação de triagem.

#### Infrastructure (`BrainHealth.Infrastructure`)

- `AppDbContext` e mapeamentos EF Core.
- Repositórios concretos.
- Serviços de aplicação (`QuestionnaireService`, `AIAnalysisService`).
- Integração com provedores de IA e composição de prompts.

### Fluxo principal da triagem

No endpoint de submissão do questionário:

1. API recebe respostas e valida request.
2. `QuestionnaireService` calcula score/resultado (quando aplicável).
3. Persiste `Questionnaire` e `Lead`.
4. Executa análise de IA com contexto da submissão.
5. Persiste ou atualiza `TriageAssessment` para o `QuestionnaireId`.
6. Retorna DTO ao frontend já com `AISynthesis` e `IdentifiedIssues`.

Esse fluxo garante persistência do resultado da triagem antes da resposta ao cliente.

---

## Frontend

### Tecnologias

- Angular 18
- Angular Material
- RxJS

### Estrutura principal

- `src/app/pages/questionnaire`: tela de triagem e envio do formulário.
- `src/app/pages/questionnaire-result`: tela de resultado/recomendação.
- `src/app/services/questionnaire.service.ts`: integração com endpoints de questionário.
- `src/app/services/ai-analysis.service.ts`: integração com recomendação de profissionais.
- `src/app/services/questionnaire-result-session.service.ts`: estado de sessão do resultado.

### Padrões usados

- Componentização com componentes reutilizáveis para perguntas.
- Estratégias para renderização de tipos de questão.
- Serviços para isolamento de chamadas HTTP.
- Navegação por rota para separar coleta de triagem e visualização de resultado.

---

## Infraestrutura e Operação

- Docker Compose para ambiente local.
- Nginx para servir frontend em container.
- Grafana para observabilidade local.
- Variáveis de ambiente para provider e credenciais de IA.

---

## Integrações

- OpenAI / provider local (via `IAIProviderClient`).
- WhatsApp (canal de contato com profissionais).