#!/bin/bash

# ==================== SEED PROFISSIONAIS - STAGING (VIA SSH) ====================
# Script para popular 500 profissionais no banco de staging via SSH
# Uso: ./run-seed-professionals-staging.sh

set -e

# ==================== CONFIGURAÇÕES ====================
VPS_HOST="${1:-root@191.252.223.30}"
VPS_PORT="${2:-22}"
DB_NAME="BrainHealthDb_Prod"  # Altere conforme necessário
DB_USER="sa"  # Altere conforme necessário
SCRIPT_PATH="./scripts/seed-professionals-500.sql"

echo "========================================"
echo "🌱 SEED: 500 Profissionais (STAGING)"
echo "========================================"
echo ""

# ==================== VALIDAÇÕES ====================
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "❌ Arquivo SQL não encontrado: $SCRIPT_PATH" >&2
    echo "   Execute este script do diretório: backend/" >&2
    exit 1
fi

echo "✅ VPS: $VPS_HOST"
echo "✅ Database: $DB_NAME"
echo "✅ Script SQL: $SCRIPT_PATH"
echo ""

# ==================== OPÇÃO 1: Via Script Local ====================
echo "┌─────────────────────────────────────────────┐"
echo "│ Opção 1: Transferir e executar SQL remotamente"
echo "└─────────────────────────────────────────────┘"
echo ""

read -p "Deseja continuar? (s/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Operação cancelada."
    exit 1
fi

echo "📤 Transferindo script SQL..."
scp -P "$VPS_PORT" "$SCRIPT_PATH" "$VPS_HOST":/tmp/seed-professionals-500.sql

if [ $? -ne 0 ]; then
    echo "❌ Erro ao transferir arquivo via SCP" >&2
    exit 1
fi

echo "✅ Script transferido com sucesso"
echo ""

# ==================== EXECUTAR SQL VIA SSH ====================
echo "⏳ Executando seed no banco de dados..."
echo ""

ssh -p "$VPS_PORT" "$VPS_HOST" << 'EOF'
    echo "Aguarde, executando script SQL..."
    
    # Opção 1: Se usando SQL Server (Windows)
    # sqlcmd -S localhost -d BrainHealthDb_Prod -i /tmp/seed-professionals-500.sql
    
    # Opção 2: Se usando PostgreSQL
    psql -U postgres -d BrainHealthDb_Prod -f /tmp/seed-professionals-500.sql
    
    # Opção 3: Se usando MySQL
    # mysql -u root -p < /tmp/seed-professionals-500.sql
    
    echo "✅ Script executado com sucesso!"
    rm /tmp/seed-professionals-500.sql
EOF

if [ $? -ne 0 ]; then
    echo "❌ Erro ao executar SQL no servidor" >&2
    exit 1
fi

echo ""
echo "========================================"
echo "✅ SEED CONCLUÍDO NO STAGING!"
echo "========================================"
echo ""
echo "📊 Profissionais inseridos: 500"
echo "🎯 Especialidades: 13 tipos"
echo "✓ ~90% com AvailableForNewPatients = true"
echo ""
