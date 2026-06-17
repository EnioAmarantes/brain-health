# Arquitetura

## Backend

Tecnologias:

- .NET 8
- Entity Framework Core
- MariaDB

Padrões:

- DDD
- Clean Architecture
- SOLID

---

## Camadas

### Presentation

Responsável por:

- Controllers
- Requests
- Responses

Não deve conter regra de negócio.

---

### Application

Responsável por:

- Casos de uso
- Serviços
- Orquestração

---

### Domain

Responsável por:

- Entidades
- Regras de negócio
- Value Objects

---

### Infrastructure

Responsável por:

- Banco de dados
- Repositórios
- Serviços externos

---

## Frontend

Tecnologias:

- Angular 18
- Angular Material

Princípios:

- Componentes reutilizáveis
- Responsividade
- Separação de responsabilidades

---

## Infraestrutura

- Docker
- Nginx
- Cloudflare
- VPS Linux

---

## Integrações

- OpenAI
- WhatsApp