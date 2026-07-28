#!/bin/bash

# ==============================================================================
# SCRIPT DE ATUALIZAÇÃO DO APK E ENVIO PARA O GITHUB (COM JAVA 21)
# ==============================================================================

# Para a execução caso ocorra algum erro
set -e

echo "🚀 Iniciando a atualização completa..."

# ------------------------------------------------------------------------------
# 1. VERIFICAÇÃO / CONFIGURAÇÃO DO JAVA
# ------------------------------------------------------------------------------
# Caso queira forçar um caminho específico do Java 21, desconecte a linha abaixo:
# export JAVA_HOME="/caminho/para/o/seu/java-21"

if [ -n "$JAVA_HOME" ]; then
    echo "☕ Usando o Java localizado em: $JAVA_HOME"
else
    echo "ℹ️  JAVA_HOME não definido explicitamente. Usando o Java padrão do sistema:"
    java -version
fi

# ------------------------------------------------------------------------------
# 2. SINCRONIZAÇÃO E COMPILAÇÃO (CAPACITOR + GRADLE)
# ------------------------------------------------------------------------------
echo "📦 1/4 Sincronizando arquivos da Web (PWA) com o Android..."
npx cap copy android

echo "🔨 2/4 Compilando o APK Android com Gradle..."
cd android
./gradlew assembleDebug
cd ..

# ------------------------------------------------------------------------------
# 3. ATUALIZAÇÃO DO REPOSITÓRIO NO GITHUB
# ------------------------------------------------------------------------------
echo "🔍 3/4 Identificando e salvando alterações no Git..."
git add .

MENSAGEM_COMMIT="Atualização automática: $(date +'%d/%m/%Y às %H:%M')"
git commit -m "$MENSAGEM_COMMIT" || echo "⚠️  Nenhuma alteração nova para salvar."

echo "⬆️ 4/4 Enviando as atualizações para o GitHub..."
git push

echo "=================================================="
echo "✅ Processo concluído com sucesso!"
echo "=================================================="