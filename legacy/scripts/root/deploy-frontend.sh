#!/bin/bash

# Deploy frontend to VPS
VPS_IP="191.252.223.30"
VPS_USER="root"

echo "=== Building frontend ==="
cd $(dirname "$0")/frontend-web
npm run build:prod

echo ""
echo "=== Compacting build ==="
tar -czf dist.tar.gz dist/
SIZE=$(du -h dist.tar.gz | cut -f1)
echo "✓ Created dist.tar.gz ($SIZE)"

echo ""
echo "=== Uploading to VPS ==="
scp dist.tar.gz ${VPS_USER}@${VPS_IP}:/tmp/

echo ""
echo "=== Extracting and deploying ==="
ssh ${VPS_USER}@${VPS_IP} << 'EOF'
cd /tmp
tar -xzf dist.tar.gz
rm -rf /var/www/brainhealth/app/frontend-web
mv dist/brain-health-web /var/www/brainhealth/app/frontend-web
chown -R www-data:www-data /var/www/brainhealth/app/frontend-web
rm dist.tar.gz
echo "✓ Frontend deployed successfully!"
ls -lh /var/www/brainhealth/app/frontend-web/ | head -10
EOF

echo ""
echo "=== Cleaning up ==="
rm dist.tar.gz
echo "✓ Done! App live at https://meunegociosimples.net"
