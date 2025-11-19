#!/bin/bash

echo "========================================="
echo "  SGU - Despliegue con HTTPS"
echo "========================================="
echo ""

# Detener servicios previos
echo "🛑 Deteniendo servicios anteriores..."
docker compose down

# Eliminar imágenes antiguas
echo "🗑️  Eliminando imágenes antiguas..."
docker rmi client:1.0-sgu-https -f 2>/dev/null || true
docker rmi server:1.0-sgu-https -f 2>/dev/null || true

# Construir y levantar servicios
echo "🏗️  Construyendo imágenes y desplegando servicios..."
docker compose up -d --build

# Esperar a que los servicios estén listos
echo "⏳ Esperando a que los servicios estén listos..."
sleep 15

# Verificar estado de los contenedores
echo ""
echo "📊 Estado de los contenedores:"
docker ps --filter "name=sgu" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "========================================="
echo "✅ Despliegue completado!"
echo "========================================="
echo ""
echo "🌐 Frontend HTTPS: https://localhost:3001"
echo "📡 Backend HTTPS: https://localhost:8444/sgu-api"
echo "🗄️  Base de Datos: localhost:3308"
echo ""
echo "⚠️  Nota: El navegador mostrará advertencia de certificado"
echo "    auto-firmado. Esto es normal en desarrollo."
echo ""
echo "📝 Para ver logs:"
echo "   docker compose logs -f"
echo ""
echo "🛑 Para detener:"
echo "   docker compose down"
echo ""
