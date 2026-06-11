#!/bin/bash

# Deploy backend to VPS
VPS_IP="191.252.223.30"
VPS_USER="root"

echo "=== Building backend ==="
cd $(dirname "$0")/backend/BrainHealth.API
dotnet publish -c Release -o ./publish

echo ""
echo "=== Compacting build ==="
tar -czf publish.tar.gz publish/
SIZE=$(du -h publish.tar.gz | cut -f1)
echo "✓ Created publish.tar.gz ($SIZE)"

echo ""
echo "=== Uploading to VPS ==="
scp publish.tar.gz ${VPS_USER}@${VPS_IP}:/tmp/

echo ""
echo "=== Deploying ==="
ssh ${VPS_USER}@${VPS_IP} << 'EOF'
cd /tmp
tar -xzf publish.tar.gz
systemctl stop brainhealth
rm -rf /var/www/brainhealth/app/backend
mv publish /var/www/brainhealth/app/backend
chown -R www-data:www-data /var/www/brainhealth/app/backend
systemctl start brainhealth
sleep 2
echo "✓ Backend deployed and started!"
systemctl status brainhealth | grep -E "Active|Loaded"
rm /tmp/publish.tar.gz
EOF

echo ""
echo "=== Cleaning up ==="
rm publish.tar.gz
echo "✓ Done! API live at https://meunegociosimples.net/api/health"
