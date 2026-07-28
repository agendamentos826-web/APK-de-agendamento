#!/bin/bash

# ==============================================================================
# SCRIPT DE ATUALIZAÇÃO DO APP-DEBUG.APK E ENVIO PARA O GITHUB
# ==============================================================================

# Para a execução do script se ocorrer qualquer erro intermediário
set -e

echo "🚀 1/6 Verificando ambiente e Java..."

# Descomente a linha abaixo e insira o caminho se precisar fixar o Java 21:
# export JAVA_HOME="/caminho/para/o/seu/java-21"

if [ -n "$JAVA_HOME" ]; then
    echo "   📍 JAVA_HOME definido em: $JAVA_HOME"
else
    echo "   📍 Usando Java padrão do sistema:"
    java -version
fi

echo "📦 2/6 Sincronizando arquivos Web (PWA) com o Android..."
npx cap copy android

echo "🔨 3/6 Compilando o arquivo app-debug.apk com Gradle..."
cd android
./gradlew assembleDebug
cd ..

# Caminho de origem gerado pelo Gradle
CAMINHO_GERADO="android/app/build/outputs/apk/debug/app-debug.apk"
NOME_FINAL="app-debug.apk"

echo "📋 4/6 Copiando $NOME_FINAL para a pasta raiz..."
if [ -f "$CAMINHO_GERADO" ]; then
    cp "$CAMINHO_GERADO" ./"$NOME_FINAL"
    echo "   ✅ Arquivo $NOME_FINAL copiado com sucesso!"
else
    echo "   ❌ Erro: O arquivo $CAMINHO_GERADO não foi encontrado."
    exit 1
fi

echo "🔍 5/6 Preparando o arquivo para envio no Git..."
git add .

# FORÇA o rastreamento do app-debug.apk no Git (mesmo que esteja no .gitignore)
git add -f "$NOME_FINAL"

# Cria a mensagem de atualização com a data e hora atual
MENSAGEM_COMMIT="Atualização do $NOME_FINAL: $(date +'%d/%m/%Y às %H:%M')"
git commit -m "$MENSAGEM_COMMIT" || echo "ℹ️ Nenhuma alteração pendente."

echo "⬆️ 6/6 Enviando as alterações para o GitHub..."
git push

echo "=================================================="
echo "✅ Sucesso! O arquivo $NOME_FINAL foi atualizado no GitHub!"
echo "=================================================="