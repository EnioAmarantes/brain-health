# Brain Health - Plano de Execucao MVP (90 dias)

## Objetivo do MVP
Validar se profissionais pagam para receber pacientes qualificados.

## O que o MVP deve ter
- Landing page com proposta clara.
- Triagem com IA (sem diagnostico).
- Lista de profissionais recomendados apos triagem.
- Perfil profissional editavel (dados essenciais).
- Painel admin simples para aprovar/ocultar profissional.
- Registro de triagens.
- Registro de clique/lead (antes de abrir WhatsApp).
- Dashboard simples com metricas de validacao.

## O que fica fora do MVP agora
- Agenda complexa.
- Prontuario, notas e relatorios clinicos.
- Videochamada.
- Pagamentos automaticos/comissao.
- App mobile.
- SSO/OAuth e outras integracoes nao essenciais.

## Roadmap operacional

## Status atual (12/06/2026)

- Fase atual: Semana 1 e Semana 2 concluidas + Semana 3 em execucao.
- Backend e frontend limpos de modulos fora do escopo MVP.
- Tracking de lead implementado antes do contato via WhatsApp.
- Disclaimer legal de IA implementado nos principais pontos do fluxo.
- Dashboard de validacao conectado ao endpoint `GET /api/metrics/mvp` no frontend admin.
- Revisao de UX e responsividade aplicada na jornada principal (entrada, triagem e listagem de profissionais).
- Fluxo de aprovacao/ocultacao de profissionais implementado no admin (backend + frontend).
- Landing page comercial de divulgacao do produto ainda nao implementada (fora do frontend do sistema).

### Checklist consolidado do MVP

- [x] Limpeza de escopo nao-MVP no codigo
- [x] Fluxo principal completo (Triagem -> Recomendacao -> Clique -> WhatsApp)
- [x] Disclaimer legal de IA nos pontos principais
- [x] Entidade/Tabela Triage dedicada
- [x] Entidade/Tabela Lead
- [x] Persistencia de tags da IA
- [x] Persistencia de UTM/source/campaign (lead tracking)
- [x] Endpoint de metricas basicas
- [x] Revisao UX/responsividade da jornada principal
- [x] Dashboard simples com metricas de validacao
- [x] Fluxo admin para aprovar/ocultar profissional

### Semana 1
- [x] Consolidar escopo no codigo.
- [x] Garantir fluxo principal:
  - [x] Triagem
  - [x] Recomendacao
  - [x] Clique em profissional
  - [x] Contato por WhatsApp
- [x] Definir disclaimer legal em todos os pontos de IA.

### Semana 2
- Implementar coleta de dados MVP:
  - [x] Entidade/Tabela `Triage`.
  - [x] Entidade/Tabela `Lead`.
  - [x] Persistir tags da IA.
  - [x] Persistir UTM/source/campaign.
- [x] Expor endpoint de metricas basicas (`GET /api/metrics/mvp`).

### Semana 3
- [ ] Construir landing page comercial de divulgacao (site institucional de aquisicao, separado do sistema).
- [x] Revisar responsividade mobile/desktop do fluxo principal.
- [ ] Preparar material comercial do Plano Fundador.

### Semana 4
- [ ] Onboarding manual dos primeiros profissionais.
- [x] Aprovacao manual no admin (fluxo tecnico implementado no produto).
- [ ] Rodar demos com rede local (Parana).

### Semanas 5-8
- [ ] Aquisição de pacientes (conteudo + trafego pago leve).
- [ ] Medir funil semanalmente.
- [ ] Converter os primeiros pagantes.

## Metricas obrigatorias (toda segunda)
- Oferta:
  - profissionais cadastrados
  - profissionais ativos
- Demanda:
  - triagens realizadas
  - triagens completas
- Conversao:
  - cliques em profissionais
  - leads gerados
  - taxa de clique
- Receita:
  - pagantes
  - MRR

## Critério de sucesso (90 dias)
- 10 profissionais pagantes.
- 1 clinica interessada em piloto.
- R$ 500-1000 de receita recorrente inicial.

## Regra de decisao
Toda funcionalidade nova deve responder: "isso aumenta triagem, lead ou conversao comercial agora?"
Se nao aumentar, fica fora do MVP.
