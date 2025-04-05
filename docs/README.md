# Pulse Flow API - Documentação

Esta pasta contém diagramas e documentação relacionada à arquitetura e ao design do sistema Pulse Flow API.

## Diagramas

Todos os diagramas são criados usando [PlantUML](https://plantuml.com/), uma ferramenta que permite a criação de diagramas através de código.

### Lista de Diagramas

1. **Fluxo de Dados do Sistema**
   - Arquivo: `diagrams/data_flow.puml`
   - Descrição: Mostra como os dados fluem através dos componentes do sistema.

2. **Arquitetura de Camadas da Aplicação**
   - Arquivo: `diagrams/architecture_layers.puml`
   - Descrição: Ilustra as diferentes camadas da aplicação e suas responsabilidades.

3. **Diagramas C4**
   - Contexto: `diagrams/c4_context.puml`
   - Contêiner: `diagrams/c4_container.puml`
   - Componente: `diagrams/c4_component.puml`
   - Descrição: Série de diagramas que fornecem diferentes níveis de detalhe sobre a arquitetura do sistema, seguindo a metodologia C4.

## Geração dos Diagramas

Os diagramas podem ser regenerados usando o script `generate_diagrams.sh` localizado na pasta raiz do projeto. Este script utiliza a CLI do PlantUML para gerar imagens a partir dos arquivos `.puml`.

```bash
./scripts/generate_diagrams.sh
```

## Requisitos

Para gerar os diagramas, você precisa ter:

1. Java Runtime Environment (JRE)
2. PlantUML JAR

Estes requisitos são verificados e, se necessário, baixados automaticamente pelo script de geração. 