#!/bin/bash

# Script para gerar diagramas PlantUML

# Verifica se o PlantUML está instalado
if ! command -v plantuml &> /dev/null; then
    echo "PlantUML não está instalado. Por favor instale usando:"
    echo "  macOS: brew install plantuml"
    echo "  Linux: sudo apt-get install plantuml"
    exit 1
fi

# Verifica se o Java está instalado
if ! command -v java &> /dev/null; then
    echo "Java não está instalado. Por favor instale usando:"
    echo "  macOS: brew install --cask temurin"
    echo "  Linux: sudo apt-get install default-jre"
    exit 1
fi

# Diretório dos diagramas
DIAGRAMS_DIR="docs/diagrams"

# Criar diretório de saída se não existir
OUTPUT_DIR="$DIAGRAMS_DIR/output"
mkdir -p "$OUTPUT_DIR"

echo "Gerando diagramas PlantUML..."

# Gerar diagramas individualmente
cd "$DIAGRAMS_DIR" || exit 1
for file in *.puml; do
    echo "Processando $file..."
    plantuml "$file"
done

# Copiar PNGs para o diretório de saída
echo "Copiando arquivos PNG para $OUTPUT_DIR..."
cp -f *.png "$OUTPUT_DIR/"

# Verificar se os diagramas foram gerados com sucesso
if [ $? -eq 0 ]; then
    echo "Diagramas gerados com sucesso em: $OUTPUT_DIR"
    # Listar os diagramas gerados
    echo "Diagramas gerados:"
    ls -la "$OUTPUT_DIR"
    # Voltar para o diretório original
    cd - > /dev/null
else
    echo "Erro ao gerar os diagramas."
    # Voltar para o diretório original
    cd - > /dev/null
    exit 1
fi

echo "Concluído!" 