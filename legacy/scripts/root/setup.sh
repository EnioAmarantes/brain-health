#!/bin/bash

# 🚀 Brain Health - Script de Setup Rápido
# Este script configura toda a aplicação com um comando

set -e

echo "🧠 Brain Health - Setup Completo"
echo "=================================="
echo ""

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para imprimir status
print_status() {
    echo -e "${BLUE}➜${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Verificar pré-requisitos
print_status "Verificando pré-requisitos..."

if ! command -v dotnet &> /dev/null; then
    print_warning ".NET SDK não encontrado. Por favor instale: https://dotnet.microsoft.com/download"
    exit 1
fi
print_success ".NET SDK encontrado"

if ! command -v node &> /dev/null; then
    print_warning "Node.js não encontrado. Por favor instale: https://nodejs.org"
    exit 1
fi
print_success "Node.js encontrado"

if ! command -v npm &> /dev/null; then
    print_warning "npm não encontrado. Por favor instale Node.js"
    exit 1
fi
print_success "npm encontrado"

echo ""
print_status "Setup do Backend..."
cd backend

print_status "Restaurando dependências .NET..."
dotnet restore > /dev/null 2>&1
print_success "Dependências .NET restauradas"

print_status "Verifique docker ou crie o banco MariaDB..."
print_warning "Para usar Docker:"
print_warning "docker run --name brainhealth-mysql -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=BrainHealthDb_Dev -p 3306:3306 -d mariadb:latest"
echo ""

cd ..

echo ""
print_status "Setup do Frontend Web..."
cd frontend-web

print_status "Instalando dependências npm..."
npm install > /dev/null 2>&1
print_success "Dependências npm instaladas"

cd ..

echo ""
print_status "Setup do Frontend Mobile..."
cd frontend-mobile

print_status "Instalando dependências npm..."
npm install > /dev/null 2>&1
print_success "Dependências npm instaladas"

cd ..

echo ""
echo "=================================="
echo -e "${GREEN}✓ Setup Completo!${NC}"
echo "=================================="
echo ""

echo "📚 Documentação Importante:"
echo "  • Leia: PROJECT_SUMMARY.md"
echo "  • Leia: USER_FLOW.md"
echo ""

echo "🚀 Para começar a trabalhar:"
echo ""
echo "Backend:"
echo "  cd backend"
echo "  dotnet watch run"
echo ""
echo "Frontend Web (novo terminal):"
echo "  cd frontend-web"
echo "  npm start"
echo ""
echo "Frontend Mobile (novo terminal):"
echo "  cd frontend-mobile"
echo "  npm start"
echo ""

echo "🌐 URLs:"
echo "  • Backend API: http://localhost:5000"
echo "  • Swagger: http://localhost:5000/swagger"
echo "  • Frontend Web: http://localhost:4200"
echo ""

echo "🧪 Para executar testes:"
echo "  Backend: cd backend && dotnet test"
echo "  Frontend: cd frontend-web && npm test"
echo ""

print_success "Tudo pronto! Divirta-se desenvolvendo 🎉"
