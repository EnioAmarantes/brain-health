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

### Semana 1
- Consolidar escopo no codigo (feito parcialmente nesta branch).
- Garantir fluxo principal:
  1) Triagem
  2) Recomendacao
  3) Clique em profissional
  4) Contato por WhatsApp
- Definir disclaimer legal em todos os pontos de IA.

### Semana 2
- Implementar coleta de dados MVP:
  - Entidade/Tabela `Triage`.
  - Entidade/Tabela `Lead`.
  - Persistir tags da IA.
  - Persistir UTM/source/campaign.
- Expor endpoint de metricas basicas.

### Semana 3
- Revisar UX da landing e jornada da triagem.
- Revisar responsividade mobile/desktop do fluxo principal.
- Preparar material comercial do Plano Fundador.

### Semana 4
- Onboarding manual dos primeiros profissionais.
- Aprovacao manual no admin.
- Rodar demos com rede local (Parana).

### Semanas 5-8
- Aquisição de pacientes (conteudo + trafego pago leve).
- Medir funil semanalmente.
- Converter os primeiros pagantes.

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
- 5 profissionais pagantes.
- 1 clinica interessada em piloto.
- R$ 500-1000 de receita recorrente inicial.

## Regra de decisao
Toda funcionalidade nova deve responder: "isso aumenta triagem, lead ou conversao comercial agora?"
Se nao aumentar, fica fora do MVP.
