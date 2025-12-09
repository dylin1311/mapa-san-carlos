#!/bin/bash

# ═══════════════════════════════════════════════════════════════
# Script de Inicialización - Mapa de San Carlos
# Dylan Cachón & Victoria Sandí - TEC 2025
# ═══════════════════════════════════════════════════════════════

echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║        INICIALIZANDO REPOSITORIO MAPA DE SAN CARLOS             ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

# ───────────────────────────────────────────────────────────────
# 1. Crear estructura de carpetas
# ───────────────────────────────────────────────────────────────

echo "📂 Creando estructura de carpetas..."

if [ ! -d "tiles" ]; then
    mkdir tiles
    touch tiles/.gitkeep
    echo "   ✓ Carpeta tiles/ creada con .gitkeep"
else
    echo "   ℹ Carpeta tiles/ ya existe"
fi

# ───────────────────────────────────────────────────────────────
# 2. Verificar archivos necesarios
# ───────────────────────────────────────────────────────────────

echo ""
echo "📋 Verificando archivos necesarios..."

archivos_necesarios=("index.html" "README.md" "tilemill_style.mss" ".gitignore")
archivos_faltantes=()

for archivo in "${archivos_necesarios[@]}"; do
    if [ -f "$archivo" ]; then
        echo "   ✓ $archivo"
    else
        echo "   ✗ $archivo (FALTANTE)"
        archivos_faltantes+=("$archivo")
    fi
done

if [ ${#archivos_faltantes[@]} -gt 0 ]; then
    echo ""
    echo "⚠️  ADVERTENCIA: Faltan archivos necesarios:"
    for archivo in "${archivos_faltantes[@]}"; do
        echo "   - $archivo"
    done
    echo ""
    echo "Por favor, copia estos archivos antes de continuar."
    read -p "¿Deseas continuar de todas formas? (s/n): " continuar
    if [ "$continuar" != "s" ]; then
        echo "Cancelado."
        exit 1
    fi
fi

# ───────────────────────────────────────────────────────────────
# 3. Inicializar Git
# ───────────────────────────────────────────────────────────────

echo ""
echo "🔧 Inicializando repositorio Git..."

if [ -d ".git" ]; then
    echo "   ℹ Git ya está inicializado"
else
    git init
    echo "   ✓ Git inicializado"
fi

# ───────────────────────────────────────────────────────────────
# 4. Configurar rama principal
# ───────────────────────────────────────────────────────────────

echo ""
echo "🌿 Configurando rama principal..."

git branch -M main
echo "   ✓ Rama principal: main"

# ───────────────────────────────────────────────────────────────
# 5. Agregar archivos
# ───────────────────────────────────────────────────────────────

echo ""
echo "➕ Agregando archivos al staging..."

git add .
echo "   ✓ Archivos agregados"

# ───────────────────────────────────────────────────────────────
# 6. Crear commit inicial
# ───────────────────────────────────────────────────────────────

echo ""
echo "💾 Creando commit inicial..."

git commit -m "Initial commit: estructura base del proyecto

- index.html: página web del mapa
- README.md: documentación completa
- tilemill_style.mss: estilos CartoCSS
- .gitignore: archivos ignorados
- tiles/.gitkeep: placeholder para tiles

Proyecto 3 - SIG
Dylan Cachón & Victoria Sandí
TEC Costa Rica - 2025"

echo "   ✓ Commit inicial creado"

# ───────────────────────────────────────────────────────────────
# 7. Configurar remote (interactivo)
# ───────────────────────────────────────────────────────────────

echo ""
echo "🔗 Configuración de repositorio remoto..."
echo ""
echo "Para conectar con GitHub, necesitas la URL de tu repositorio."
echo "Formato: https://github.com/TU-USUARIO/mapa-san-carlos.git"
echo ""
read -p "Ingresa la URL de tu repositorio GitHub (o Enter para omitir): " repo_url

if [ -n "$repo_url" ]; then
    git remote add origin "$repo_url"
    echo "   ✓ Remote 'origin' configurado: $repo_url"
    
    echo ""
    read -p "¿Deseas hacer push ahora? (s/n): " hacer_push
    
    if [ "$hacer_push" = "s" ]; then
        echo ""
        echo "⬆️  Subiendo cambios a GitHub..."
        git push -u origin main
        echo "   ✓ Cambios subidos exitosamente"
    else
        echo ""
        echo "ℹ️  Para subir cambios más tarde, usa:"
        echo "   git push -u origin main"
    fi
else
    echo ""
    echo "ℹ️  Remote no configurado."
    echo "   Para configurarlo más tarde, usa:"
    echo "   git remote add origin URL"
    echo "   git push -u origin main"
fi

# ───────────────────────────────────────────────────────────────
# 8. Resumen final
# ───────────────────────────────────────────────────────────────

echo ""
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                     ✓ INICIALIZACIÓN COMPLETA                    ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""
echo "📊 Estado actual:"
git status --short
echo ""
echo "📁 Estructura:"
tree -L 2 -a 2>/dev/null || ls -la
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "PRÓXIMOS PASOS:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Si aún no tienes repo en GitHub:"
echo "   - Ir a https://github.com/new"
echo "   - Nombre: mapa-san-carlos"
echo "   - Public"
echo "   - NO marcar 'Add a README'"
echo "   - Create repository"
echo ""
echo "2. Conectar y subir (si no lo hiciste antes):"
echo "   git remote add origin https://github.com/TU-USUARIO/mapa-san-carlos.git"
echo "   git push -u origin main"
echo ""
echo "3. Activar GitHub Pages:"
echo "   Settings → Pages → Branch: main → Save"
echo ""
echo "4. Copiar URL generada y actualizar README.md"
echo ""
echo "5. Cuando tengas los tiles:"
echo "   - Borrar tiles/.gitkeep"
echo "   - Copiar tiles/ al proyecto"
echo "   - git add tiles/"
echo "   - git commit -m 'Add map tiles'"
echo "   - git push"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✨ ¡Listo para publicar tu mapa! ✨"
echo ""
