# Scripts de Utilidade

Esta pasta contém scripts de utilidade para o projeto Pulse Flow API.

## Lista de Scripts

### generate_diagrams.sh

Script para gerar diagramas PlantUML a partir dos arquivos `.puml` na pasta `docs/diagrams`.

**Uso:**
```bash
# Tornar o script executável
chmod +x scripts/generate_diagrams.sh

# Executar o script
./scripts/generate_diagrams.sh
```

**Funcionalidades:**
- Gera arquivos PNG a partir dos diagramas PlantUML
- Verifica automaticamente se o Java está instalado
- Baixa automaticamente o JAR do PlantUML se necessário
- Salva os diagramas gerados na pasta `docs/images`

**Requisitos:**
- Java Runtime Environment (JRE)

**Exemplo de execução:**

Execute o script quando:
1. Novos diagramas forem adicionados
2. Diagramas existentes forem modificados
3. Você quiser visualizar os diagramas em formato de imagem 