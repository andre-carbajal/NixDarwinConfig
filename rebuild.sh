#!/bin/bash

# Salir si hay errores
set -e

echo "🔨 Construyendo nueva configuración..."
nix build .#darwinConfigurations.andrecarbajalvargas.system

echo "🚀 Aplicando cambios..."
sudo ./result/sw/bin/darwin-rebuild switch --flake .#andrecarbajalvargas

echo "🧹 Limpiando archivos temporales..."
rm result

echo "✅ ¡Configuración actualizada con éxito!"
