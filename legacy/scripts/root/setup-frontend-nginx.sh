#!/bin/bash

# Script de Setup - Frontend + Nginx
# Execute na VPS como root

set -e

echo "🚀 Configurando Frontend + Nginx"
echo "=================================="
echo ""

# 1. Criar diretório do frontend se não existir
echo "📁 Criando diretórios..."
mkdir -p /var/www/brainhealth/app/frontend-web
chown -R www-data:www-data /var/www/brainhealth/app/frontend-web
chmod -R 755 /var/www/brainhealth/app/frontend-web

# 2. Copiar arquivo de serviço
echo "🔧 Instalando serviço systemd..."
cp brain-health-frontend.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable brain-health-frontend.service

# 3. Configurar Nginx
echo "⚙️  Configurando Nginx..."
cp nginx-frontend.conf /etc/nginx/sites-available/brain-health

# Remover default se existir
if [ -L /etc/nginx/sites-enabled/default ]; then
    rm /etc/nginx/sites-enabled/default
fi

# Ativar configuração
if [ -L /etc/nginx/sites-enabled/brain-health ]; then
    rm /etc/nginx/sites-enabled/brain-health
fi
ln -s /etc/nginx/sites-available/brain-health /etc/nginx/sites-enabled/

# Testar configuração
if nginx -t; then
    echo "  ✓ Configuração Nginx validada"
    systemctl reload nginx
else
    echo "  ❌ Erro na configuração Nginx"
    exit 1
fi

# 4. Criar diretórios de log
echo "📝 Criando diretórios de log..."
mkdir -p /var/log/nginx
chown www-data:www-data /var/log/nginx
chmod 755 /var/log/nginx

echo ""
echo "✅ Setup concluído!"
echo ""
echo "📝 Próximas etapas:"
echo "  1. Fazer upload dos arquivos do frontend"
echo "  2. Reiniciar o serviço:"
echo "     sudo systemctl restart brain-health-frontend"
echo "  3. Verificar status:"
echo "     sudo systemctl status brain-health-frontend"
echo "     sudo systemctl status nginx"
echo "  4. Acessar:"
echo "     http://meunegociosimples.net"
echo ""
