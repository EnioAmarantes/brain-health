# Coding Standards

## Backend

### Regras

- Utilizar Clean Architecture
- Utilizar DDD
- Utilizar SOLID

---

### Não Fazer

- Não criar regras de negócio em Controllers
- Não acessar banco diretamente na Presentation
- Não criar Repository Genérico

---

### Testes

Toda regra de negócio deve possuir teste unitário.

---

## Frontend

### Regras

- Utilizar componentes reutilizáveis
- Evitar lógica complexa em templates

---

### Responsividade

Todas as telas devem funcionar em:

- Desktop
- Tablet
- Mobile

---

## Banco

### Convenções

- Chaves primárias: Id
- Datas em UTC
- Soft Delete quando necessário

---

## Commits

Formato:

feat: descrição

fix: descrição

refactor: descrição

test: descrição