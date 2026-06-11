#!/bin/bash

# Script para executar testes do Backend Brain Health
# Uso: ./run-backend-tests.sh [option]

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$PROJECT_DIR/backend"
TESTS_PROJECT="$BACKEND_DIR/BrainHealth.Tests/BrainHealth.Tests.csproj"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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
    echo "5) Limpar e rebuildar"
    echo "6) Gerar relatório de cobertura"
    echo "0) Sair"
    echo ""
}

# Executar todos os testes
run_all_tests() {
    print_header "Executando todos os testes"
    cd "$BACKEND_DIR"
    dotnet test "$TESTS_PROJECT" -v normal
    print_success "Testes concluídos"
}

# Executar com cobertura
run_with_coverage() {
    print_header "Executando testes com cobertura"
    cd "$BACKEND_DIR"
    dotnet test "$TESTS_PROJECT" /p:CollectCoverageMetrics=true /p:CoverageOutputFormat=cobertura
    print_success "Cobertura gerada"
    print_info "Arquivo: coverage.cobertura.xml"
}

# Executar teste específico
run_specific_test() {
    echo "Digite o nome do teste (ex: AuthServiceTests ou LoginAsync_WithValidCredentials):"
    read -r test_name
    
    if [ -z "$test_name" ]; then
        print_error "Nome do teste não fornecido"
        return 1
    fi
    
    print_header "Executando: $test_name"
    cd "$BACKEND_DIR"
    dotnet test "$TESTS_PROJECT" --filter "FullyQualifiedName~$test_name"
    print_success "Teste concluído"
}

# Executar em modo watch
run_watch_mode() {
    print_header "Executando em modo watch"
    print_info "Pressione Ctrl+C para sair"
    cd "$BACKEND_DIR"
    dotnet watch test "$TESTS_PROJECT"
}

# Limpar e rebuildar
clean_and_rebuild() {
    print_header "Limpando e reconstruindo"
    cd "$BACKEND_DIR"
    
    print_info "Limpando..."
    dotnet clean BrainHealth.Tests/ || true
    rm -rf BrainHealth.Tests/bin BrainHealth.Tests/obj || true
    
    print_info "Restaurando dependências..."
    dotnet restore
    
    print_info "Construindo..."
    dotnet build
    
    print_success "Projeto limpo e reconstruído"
}

# Gerar relatório de cobertura
generate_coverage_report() {
    print_header "Gerando relatório de cobertura"
    cd "$BACKEND_DIR"
    
    print_info "Instalando ReportGenerator..."
    dotnet tool install -g dotnet-reportgenerator-globaltool || true
    
    print_info "Executando testes com cobertura..."
    dotnet test "$TESTS_PROJECT" /p:CollectCoverageMetrics=true /p:CoverageOutputFormat=cobertura
    
    print_info "Gerando relatório HTML..."
    reportgenerator -reports:"coverage.cobertura.xml" -targetdir:"coverage-report" -reporttypes:Html
    
    print_success "Relatório gerado em: coverage-report/"
    print_info "Abra coverage-report/index.html para visualizar"
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
            5) clean_and_rebuild ;;
            6) generate_coverage_report ;;
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
        clean) clean_and_rebuild ;;
        report) generate_coverage_report ;;
        *) 
            echo "Uso: $0 [all|coverage|specific|watch|clean|report]"
            exit 1
            ;;
    esac
fi
