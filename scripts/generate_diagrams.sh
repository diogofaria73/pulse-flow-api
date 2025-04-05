#!/bin/bash

# Script para gerar diagramas PlantUML

# Definição de cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Diretórios
DIAGRAMS_DIR="docs/diagrams"
OUTPUT_DIR="docs/images"
PLANTUML_JAR="$OUTPUT_DIR/plantuml.jar"

# Função para imprimir mensagens
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar se o diretório de diagramas existe
if [ ! -d "$DIAGRAMS_DIR" ]; then
    print_error "Diretório de diagramas não encontrado: $DIAGRAMS_DIR"
    exit 1
fi

# Criar diretório de saída se não existir
mkdir -p "$OUTPUT_DIR"

# Verificar se o Java está instalado
if ! command -v java &> /dev/null; then
    print_error "Java não está instalado. Por favor, instale o Java para continuar."
    exit 1
fi

# Baixar PlantUML se necessário
if [ ! -f "$PLANTUML_JAR" ]; then
    print_message "Baixando PlantUML JAR..."
    curl -L -o "$PLANTUML_JAR" "https://github.com/plantuml/plantuml/releases/download/v1.2023.11/plantuml-1.2023.11.jar"
    
    if [ $? -ne 0 ]; then
        print_error "Falha ao baixar PlantUML JAR."
        exit 1
    fi
    
    print_message "PlantUML JAR baixado com sucesso."
fi

# Encontrar todos os arquivos .puml e gerar imagens
print_message "Gerando diagramas..."
TOTAL_FILES=$(find "$DIAGRAMS_DIR" -name "*.puml" | wc -l)
CURRENT=0
SUCCESS=0
FAILED=0

for puml_file in $(find "$DIAGRAMS_DIR" -name "*.puml"); do
    CURRENT=$((CURRENT + 1))
    filename=$(basename "$puml_file" .puml)
    output_path="$OUTPUT_DIR/$filename.png"
    
    echo -ne "Processando: [$CURRENT/$TOTAL_FILES] $filename\r"
    
    java -jar "$PLANTUML_JAR" -tpng "$puml_file" -o "$(realpath "$OUTPUT_DIR")"
    
    if [ $? -eq 0 ]; then
        SUCCESS=$((SUCCESS + 1))
    else
        FAILED=$((FAILED + 1))
        print_error "Falha ao gerar diagrama: $filename"
    fi
done

echo ""

# Resumo
if [ $FAILED -eq 0 ]; then
    print_message "Todos os diagramas foram gerados com sucesso."
else
    print_warning "Gerados: $SUCCESS | Falhas: $FAILED"
fi

print_message "Os diagramas estão disponíveis em: $OUTPUT_DIR"

exit 0 