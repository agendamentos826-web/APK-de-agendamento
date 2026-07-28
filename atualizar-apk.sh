#!/bin/bash

# ==============================================================================
# SCRIPT DE ATUALIZAÇÃO DO APK E ENVIO AUTOMÁTICO PARA O GITHUB (COM JAVA)
# ==============================================================================

# Interruptor de segurança: para o script imediatamente se ocorrer qualquer erro
set -e

echo "🚀 Iniciando o processo completo de atualização..."

# ------------------------------------------------------------------------------
# 1. VERIFICAÇÃO / CONFIGURAÇÃO DO JAVA 21
# ------------------------------------------------------------------------------
echo "☕ 1/6 Verificando a versão do Java..."

# SE PRECISAR DEFINIR O CAMINHO DO JAVA 21 MANUALMENTE, DESCOMENTE A LINHA ABAIXO:
# export JAVA_HOME="/caminho/para/o/seu/java-21"

if [ -n "$JAVA_HOME" ]; then
    echo "   📍 Usando JAVA_HOME definido em: $JAVA_HOME"
else
    echo "   📍 JAVA_HOME não definido explicitamente. Usando o Java padrão do sistema:"
    java -version
fi

# ------------------------------------------------------------------------------
# 2. SINCRONIZAÇÃO E COMPILAÇÃO (CAPACITOR + GRADLE)
# ------------------------------------------------------------------------------
echo "📦 2/6 Sincronizando arquivos da Web (PWA) com o projeto Android..."
npx cap copy android

echo "🔨 3/6 Compilando o novo APK nativo com o Gradle..."
cd android
./gradlew assembleDebug
cd ..

# ------------------------------------------------------------------------------
# 3. ORGANIZAÇÃO DO ARQUIVO GERADO
# ------------------------------------------------------------------------------
NOME_APK="app-barbearia.apk"

echo "📋 4/6 Copiando o APK gerado para a raiz ($NOME_APK)..."
cp android/app/build/outputs/apk/debug/app-debug.apk ./"$NOME_APK"

# ------------------------------------------------------------------------------
# 4. PREPARAÇÃO E ENVIO PARA O GITHUB
# ------------------------------------------------------------------------------
echo "🔍 5/6 Preparando os arquivos para o versionamento no Git..."
git add .

# FORÇA a inclusão do APK no Git, superando limitações do .gitignore
git add -f "$NOME_APK"

# Define a mensagem do commit com a data e hora do seu sistema
MENSAGEM_COMMIT="Atualização do APK: $(date +'%d/%m/%Y às %H:%M')"
git commit -m "$MENSAGEM_COMMIT" || echo "ℹ️ Nenhuma alteração nova detectada."

echo "⬆️ 6/6 Enviando as atualizações para o GitHub..."
git push

echo "=================================================="
echo "✅ Sucesso! O arquivo $NOME_APK foi gerado e atualizado no GitHub!"
echo "=================================================="