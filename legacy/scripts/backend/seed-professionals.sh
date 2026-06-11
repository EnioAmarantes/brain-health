#!/bin/bash

# ==================== SEED PROFISSIONAIS - WRAPPER UNIVERSAL ====================
# Script que roda seed tanto em LOCAL quanto em STAGING
# Detecta automaticamente qual executar
# Uso: ./seed-professionals.sh [local|staging]

set -e

# ==================== CORES PARA OUTPUT ====================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ==================== FUNÇÕES ====================
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${GREEN}🌱 $1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# ==================== MAIN ====================

ENVIRONMENT="${1:-menu}"

if [ "$ENVIRONMENT" = "menu" ]; then
    print_header "Seed de Profissionais - Escolha o Ambiente"
    echo "1) Local (Desenvolvimento)"
    echo "2) Staging (via SSH)"
    echo "0) Cancelar"
    echo ""
    read -p "Escolha uma opção (0-2): " choice
    
    case $choice in
        1) ENVIRONMENT="local" ;;
        2) ENVIRONMENT="staging" ;;
        0) echo "Cancelado."; exit 0 ;;
        *) print_error "Opção inválida"; exit 1 ;;
    esac
fi

# ==================== SEED LOCAL ====================
if [ "$ENVIRONMENT" = "local" ] || [ "$ENVIRONMENT" = "dev" ]; then
    print_header "Rodar Seed Localmente"
    
    # Verificar se o diretório do projeto existe
    if [ ! -d "BrainHealth.API" ]; then
        print_error "Diretório BrainHealth.API não encontrado"
        print_info "Execute este script do diretório: backend/"
        exit 1
    fi
    
    print_info "Ambiente: DEVELOPMENT"
    print_info "Diretório: $(pwd)/BrainHealth.API"
    echo ""
    
    read -p "Continuar? (s/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelado."
        exit 1
    fi
    
    cd BrainHealth.API
    
    echo ""
    print_info "Configurando variáveis de ambiente..."
    export ASPNETCORE_ENVIRONMENT=Development
    export SEED_TEST_PROFESSIONALS=true
    
    echo ""
    print_info "Iniciando aplicação com seed..."
    print_warning "Pressione Ctrl+C para parar"
    echo ""
    
    dotnet run
    
# ==================== SEED STAGING VIA SSH ====================
elif [ "$ENVIRONMENT" = "staging" ] || [ "$ENVIRONMENT" = "stg" ]; then
    print_header "Rodar Seed em STAGING (via SSH)"
    
    # Configurações
    VPS_HOST="${VPS_HOST:-root@191.252.223.30}"
    VPS_PORT="${VPS_PORT:-22}"
    SCRIPT_FILE="./scripts/seed-professionals-500.sql"
    
    # Validações
    if [ ! -f "$SCRIPT_FILE" ]; then
        print_error "Script SQL não encontrado: $SCRIPT_FILE"
        print_info "Execute este script do diretório: backend/"
        exit 1
    fi
    
    echo "Configurações:"
    print_info "VPS Host: $VPS_HOST"
    print_info "VPS Port: $VPS_PORT"
    print_info "Script: $SCRIPT_FILE"
    echo ""
    
    read -p "Continuar? (s/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelado."
        exit 1
    fi
    
    print_warning "Certifique-se de que:"
    print_warning "  - SSH key está configurada"
    print_warning "  - Servidor está acessível"
    echo ""
    
    echo "Testando conexão SSH..."
    if ! ssh -p "$VPS_PORT" "$VPS_HOST" "echo 'SSH OK'" > /dev/null 2>&1; then
        print_error "Não foi possível conectar ao servidor via SSH"
        print_info "Verifique: VPS_HOST, VPS_PORT, e SSH key"
        exit 1
    fi
    print_success "Conexão SSH estabelecida"
    echo ""
    
    echo "Transferindo arquivo..."
    if ! scp -P "$VPS_PORT" "$SCRIPT_FILE" "$VPS_HOST":/tmp/seed-professionals-500.sql > /dev/null 2>&1; then
        print_error "Erro ao transferir arquivo"
        exit 1
    fi
    print_success "Arquivo transferido"
    echo ""
    
    echo "Executando seed no servidor..."
    ssh -p "$VPS_PORT" "$VPS_HOST" << 'REMOTE_SCRIPT'
        echo "⏳ Executando script SQL..."
        
        # IMPORTANTE: Altere conforme seu banco de dados!
        # Para SQL Server (Windows):
        sqlcmd -S localhost -d BrainHealthDb_Prod -i /tmp/seed-professionals-500.sql
        
        # Para PostgreSQL (Linux):
        # psql -U postgres -d BrainHealthDb_Prod -f /tmp/seed-professionals-500.sql
        
        # Para MySQL:
        # mysql -u root -p < /tmp/seed-professionals-500.sql
        
        # Limpeza
        rm /tmp/seed-professionals-500.sql
        
        echo "✅ Script executado com sucesso!"
REMOTE_SCRIPT
    
    if [ $? -eq 0 ]; then
        print_success "Seed completo no servidor!"
    else
        print_error "Erro ao executar script no servidor"
        exit 1
    fi
    
else
    print_error "Ambiente desconhecido: $ENVIRONMENT"
    print_info "Use: ./seed-professionals.sh [local|staging|menu]"
    exit 1
fi

echo ""
print_header "Seed Concluído!"
echo ""
print_success "500 Profissionais inseridos com sucesso"
print_info "Especialidades: 13 tipos"
print_info "Disponibilidade: ~90% com AvailableForNewPatients = true"
echo ""
