#!/bin/bash

# Script para executar testes do Frontend Brain Health
# Uso: ./run-frontend-tests.sh [option]

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRONTEND_DIR="$PROJECT_DIR/frontend-web"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Funções
print_header() {
    echo -e "${GREEN}======================================${NC}"
    echo -e "${GREEN}$1${NC}"
    echo -e "${GREEN}======================================${NC}"
}

print_error() {
    echo -e "${RED}❌ Erro: $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# Menu de opções
show_menu() {
    echo ""
    echo "Escolha uma opção:"
    echo "1) Executar todos os testes"
    echo "2) Executar com cobertura"
    echo "3) Executar teste específico"
    echo "4) Executar em modo watch"
    echo "5) Executar com headless Chrome (CI/CD)"
    echo "6) Instalar dependências"
    echo "0) Sair"
    echo ""
}

# Executar todos os testes
run_all_tests() {
    print_header "Executando todos os testes"
    cd "$FRONTEND_DIR"
    npm test
}

# Executar com cobertura
run_with_coverage() {
    print_header "Executando testes com cobertura"
    cd "$FRONTEND_DIR"
    ng test --code-coverage --watch=false
    print_success "Cobertura gerada"
    print_info "Relatório: coverage/index.html"
}

# Executar teste específico
run_specific_test() {
    echo "Digite o padrão do arquivo (ex: auth.service.spec.ts):"
    read -r pattern
    
    if [ -z "$pattern" ]; then
        print_error "Padrão não fornecido"
        return 1
    fi
    
    print_header "Executando: $pattern"
    cd "$FRONTEND_DIR"
    ng test --include="**/$pattern" --watch=false
    print_success "Teste concluído"
}

# Executar em modo watch
run_watch_mode() {
    print_header "Executando em modo watch"
    print_info "Pressione 'q' para sair"
    cd "$FRONTEND_DIR"
    ng test
}

# Executar com headless Chrome
run_headless() {
    print_header "Executando em modo headless"
    cd "$FRONTEND_DIR"
    ng test --watch=false --browsers=ChromeHeadless
    print_success "Testes concluídos"
}

# Instalar dependências
install_dependencies() {
    print_header "Instalando dependências"
    cd "$FRONTEND_DIR"
    npm install
    print_success "Dependências instaladas"
}

# Main
if [ "$1" = "" ]; then
    # Menu interativo
    while true; do
        show_menu
        read -p "Opção: " choice
        
        case $choice in
            1) run_all_tests ;;
            2) run_with_coverage ;;
            3) run_specific_test ;;
            4) run_watch_mode ;;
            5) run_headless ;;
            6) install_dependencies ;;
            0) echo "Saindo..."; exit 0 ;;
            *) print_error "Opção inválida" ;;
        esac
    done
else
    # Execução com argumento
    case $1 in
        all) run_all_tests ;;
        coverage) run_with_coverage ;;
        specific) run_specific_test ;;
        watch) run_watch_mode ;;
        headless) run_headless ;;
        install) install_dependencies ;;
        *) 
            echo "Uso: $0 [all|coverage|specific|watch|headless|install]"
            exit 1
            ;;
    esac
fi
