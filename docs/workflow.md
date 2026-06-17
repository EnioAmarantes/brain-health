# Workflow de Colaboracao BrainHealth

## Objetivo

Padronizar como transformar ideia em entrega com qualidade, reduzindo retrabalho e melhorando a comunicacao entre produto, arquitetura, backend e frontend.

---

## Fontes de verdade

- Visao e direcionamento: docs/vision.md
- Prioridade e fase: docs/roadmap.md
- Escopo atual: docs/current-sprint.md
- Regras de negocio: docs/business-rules.md
- Dominio: docs/domain.md
- Decisoes tecnicas: docs/architecture.md
- Padroes de implementacao: docs/coding-standards.md

Em caso de conflito:
1. current-sprint.md (curto prazo)
2. business-rules.md (comportamento)
3. architecture.md e coding-standards.md (implementacao)
4. roadmap.md e vision.md (estrategia)

---

## Fluxo padrao (ideia -> producao)

### 1) Descoberta de produto (PO)

Entrada: ideia de funcionalidade.

Usar: docs/agents/product-owner.md

Saida esperada:
- Epico
- Historias
- Criterios de aceite
- Fora de escopo
- Riscos e dependencias

Gate de saida:
- Item alinhado ao MVP e sprint atual
- Regras de negocio afetadas identificadas

---

### 2) Desenho tecnico (Architect)

Entrada: historias e criterios de aceite.

Usar: docs/agents/architect.md

Saida esperada:
- Entidades impactadas
- Casos de uso
- Servicos/interfaces
- DTOs/contratos
- Migracoes
- Impacto em testes

Gate de saida:
- Sem regra de negocio na Presentation
- Sem acesso a banco fora da Infrastructure
- Solucao aderente a DDD/Clean Architecture

---

### 3) Implementacao backend

Entrada: desenho tecnico aprovado.

Usar: docs/agents/backend-engineer.md

Saida esperada:
- Endpoints e servicos implementados
- Migracoes quando necessario
- Testes unitarios para regras novas

Gate de saida:
- Build sem erros
- Testes relevantes passando
- Regras de negocio cobertas por teste

---

### 4) Implementacao frontend

Entrada: contratos backend e criterios de aceite.

Usar: docs/agents/frontend-engineer.md

Saida esperada:
- UI funcional e responsiva
- Avisos legais de IA quando aplicavel
- Fluxo aderente ao dominio

Gate de saida:
- Desktop/tablet/mobile ok
- Sem logica complexa em template
- Sem funcionalidades fora da sprint

---

### 5) Validacao final

Checklist final por feature:
- Criterios de aceite atendidos
- Escopo respeitado
- Regressao principal testada
- Logs e observabilidade basica validos

---

## Modelo de comunicacao com IA

Use sempre este formato ao pedir implementacao:

1. Contexto de negocio (1-2 linhas)
2. Escopo exato (o que entra)
3. Fora de escopo (o que nao entra)
4. Criterios de aceite
5. Restricoes tecnicas

Template curto:

"Contexto: ...
Escopo: ...
Fora de escopo: ...
Criterios de aceite: ...
Restricoes: seguir docs/workflow.md e docs/coding-standards.md"

---

## Definicao de pronto (DoD)

Uma entrega so esta pronta quando:
- atende criterios de aceite
- respeita arquitetura e padroes
- possui testes para regra de negocio
- nao quebra fluxos existentes
- possui resumo tecnico do que mudou

---

## Cadencia recomendada

- Planejamento: definir 1 objetivo por vez
- Execucao: entregar em fatias pequenas
- Revisao: validar resultado contra aceite
- Ajuste: corrigir antes de iniciar novo item

Esse ciclo reduz retrabalho e acelera aprendizagem continua do projeto.