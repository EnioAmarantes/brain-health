# Gap Analysis MVP - BrainHealth

Data: 2026-06-17

## Contexto

Analise baseada em:
- [docs/current-sprint.md](docs/current-sprint.md#L1)
- [docs/roadmap.md](docs/roadmap.md#L1)
- [docs/business-rules.md](docs/business-rules.md#L1)
- [docs/domain.md](docs/domain.md#L1)

## Impacto da alteracao em dominio (Patient)

O dominio agora declara explicitamente que Patient pode estar logado ou atuar anonimamente em [docs/domain.md](docs/domain.md#L5).

Impacto no diagnostico:
1. O suporte anonimo deixa de ser apenas decisao de produto/UX e vira regra de dominio.
2. Qualquer endpoint/fluxo que exija autenticacao no caminho anonimo passa a ser nao aderente ao dominio.
3. As metricas de MVP precisam refletir o volume de triagem anonima, nao apenas triagens vinculadas a paciente autenticado.

Conclusao de impacto:
- O gap de autorizacao no fluxo anonimo sobe para bloqueador direto de MVP.
- O gap de metricas de triagem sobe para risco alto de decisao de negocio incorreta.

## Findings priorizados

### 1) Bloqueador - Fluxo anonimo quebra na analise com IA

Evidencias:
- Controller exige Patient por padrao em [backend/BrainHealth.API/Controllers/QuestionnairesController.cs](backend/BrainHealth.API/Controllers/QuestionnairesController.cs#L13)
- Endpoint de analise por questionnaireId sem AllowAnonymous em [backend/BrainHealth.API/Controllers/QuestionnairesController.cs](backend/BrainHealth.API/Controllers/QuestionnairesController.cs#L268)
- Frontend anonimo chama esse endpoint em [frontend-web/src/app/pages/questionnaire/questionnaire-screen.component.ts](frontend-web/src/app/pages/questionnaire/questionnaire-screen.component.ts#L1100)

Impacto:
- Usuario anonimo salva resposta, mas pode falhar ao obter recomendacoes.

### 2) Critico - Contrato de Professionals desalinhado entre frontend e backend

Evidencias:
- Backend expõe busca e detalhe em [backend/BrainHealth.API/Controllers/ProfessionalsController.cs](backend/BrainHealth.API/Controllers/ProfessionalsController.cs#L38) e [backend/BrainHealth.API/Controllers/ProfessionalsController.cs](backend/BrainHealth.API/Controllers/ProfessionalsController.cs#L68)
- Frontend chama endpoints nao existentes recommended/specialties em [frontend-web/src/app/services/professional.service.ts](frontend-web/src/app/services/professional.service.ts#L100) e [frontend-web/src/app/services/professional.service.ts](frontend-web/src/app/services/professional.service.ts#L111)
- Frontend usa query params diferentes do request backend em [frontend-web/src/app/services/professional.service.ts](frontend-web/src/app/services/professional.service.ts#L127), [frontend-web/src/app/services/professional.service.ts](frontend-web/src/app/services/professional.service.ts#L145), [backend/BrainHealth.Core/DTOs/ProfessionalDtos.cs](backend/BrainHealth.Core/DTOs/ProfessionalDtos.cs#L198)

Impacto:
- Listagem e filtros podem quebrar ou trazer resultados incorretos.

### 3) Critico - Contrato de Auth desalinhado (register/refresh)

Evidencias:
- Frontend usa rotas register/patient, register/professional e refresh-token em [frontend-web/src/app/services/auth.service.ts](frontend-web/src/app/services/auth.service.ts#L88), [frontend-web/src/app/services/auth.service.ts](frontend-web/src/app/services/auth.service.ts#L104), [frontend-web/src/app/services/auth.service.ts](frontend-web/src/app/services/auth.service.ts#L125)
- Backend expõe register-patient, register-professional e refresh em [backend/BrainHealth.API/Controllers/AuthController.cs](backend/BrainHealth.API/Controllers/AuthController.cs#L81), [backend/BrainHealth.API/Controllers/AuthController.cs](backend/BrainHealth.API/Controllers/AuthController.cs#L45), [backend/BrainHealth.API/Controllers/AuthController.cs](backend/BrainHealth.API/Controllers/AuthController.cs#L153)

Impacto:
- Cadastro e renovacao de sessao quebram no cliente.

### 4) Alto - Navegacao para signup sem rota existente

Evidencias:
- Navega para signup profissional em [frontend-web/src/app/pages/login/professional-login.component.ts](frontend-web/src/app/pages/login/professional-login.component.ts#L259)
- Navega para signup paciente em [frontend-web/src/app/pages/login/patient-login.component.ts](frontend-web/src/app/pages/login/patient-login.component.ts#L431)
- Nao existe rota signup em [frontend-web/src/app/app.routes.ts](frontend-web/src/app/app.routes.ts#L11)

Impacto:
- Conversao de novos usuarios bloqueada em parte do funil.

### 5) Alto - Suite de testes quebrada e fora da solucao principal

Evidencias:
- Solucao principal nao inclui projeto de testes em [backend/BrainHealth.sln](backend/BrainHealth.sln#L5)
- Projeto de testes compila com erros de contratos/DTOs desatualizados em [backend/BrainHealth.Tests/BrainHealth.Tests.csproj](backend/BrainHealth.Tests/BrainHealth.Tests.csproj#L1)

Impacto:
- Sem rede de seguranca confiavel para evoluir MVP.

### 6) Alto - Regra de inadimplencia nao aplicada no lead

Evidencias:
- Regra de negocio em [docs/business-rules.md](docs/business-rules.md#L31)
- Criacao de lead sem validacao de assinatura em [backend/BrainHealth.Infrastructure/Services/LeadService.cs](backend/BrainHealth.Infrastructure/Services/LeadService.cs#L33)

Impacto:
- Risco de violacao de regra comercial e distribuicao indevida de leads.

### 7) Alto (subiu com alteracao de dominio) - Metricas de triagem subcontam fluxo anonimo

Evidencias:
- Metricas usam Triages em [backend/BrainHealth.Infrastructure/Services/MvpMetricsService.cs](backend/BrainHealth.Infrastructure/Services/MvpMetricsService.cs#L37)
- Fluxo autenticado cria Triage em [backend/BrainHealth.Infrastructure/Services/QuestionnaireService.cs](backend/BrainHealth.Infrastructure/Services/QuestionnaireService.cs#L78)
- Fluxo anonimo nao cria Triage em [backend/BrainHealth.Infrastructure/Services/QuestionnaireService.cs](backend/BrainHealth.Infrastructure/Services/QuestionnaireService.cs#L87)

Impacto:
- KPI de demanda pode subestimar uso real e enviesar decisoes de validacao de mercado.

### 8) Medio - Item de sprint de landing page de profissionais sem entrega dedicada clara

Evidencias:
- Item previsto em [docs/current-sprint.md](docs/current-sprint.md#L7)
- Rotas atuais focam login/questionario/profissionais em [frontend-web/src/app/app.routes.ts](frontend-web/src/app/app.routes.ts#L18), [frontend-web/src/app/app.routes.ts](frontend-web/src/app/app.routes.ts#L33), [frontend-web/src/app/app.routes.ts](frontend-web/src/app/app.routes.ts#L38)

Impacto:
- Risco de nao cumprir objetivo de aquisicao do sprint.

## O que aumenta no diagnostico apos a alteracao de dominio

Incrementos objetivos:
1. Gap 1 e Gap 7 sobem de severidade por conflito direto com regra de dominio explicita (paciente anonimo).
2. Entra criterio de aceite adicional para MVP: todos os passos de triagem e recomendacao devem funcionar para usuario anonimo ponta a ponta.
3. Entra criterio de metricas: painel MVP deve representar triagens anonimas e autenticadas sem distorcao.

## Plano de fechamento recomendado (ordem)

1. Corrigir autorizacao do endpoint de analise por questionnaireId para suportar fluxo anonimo sem quebrar seguranca.
2. Unificar contratos frontend/backend de Auth e Professionals (rotas e parametros).
3. Corrigir rotas de signup (criar telas/rotas ou ajustar CTA para fluxo existente).
4. Aplicar regra de inadimplencia na criacao de lead.
5. Ajustar metricas para incluir triagem anonima (ou registrar Triage anonima de forma coerente).
6. Reabilitar suite de testes e incluir projeto de testes na solucao.

## Risco residual se publicar sem ajustes

- Falhas no funil anonimo (principal para aquisicao inicial).
- Quebras de cadastro/refresh no frontend.
- KPI de validacao distorcido.
- Ausencia de confianca em regressao por testes quebrados.