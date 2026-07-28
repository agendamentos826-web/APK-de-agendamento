#!/bin/bash

# ==============================================================================
# SCRIPT AUTOMÁTICO COM GARANTIA DE CONFIGURAÇÃO (CAPACITOR + GRADLE)
# ==============================================================================

# Interrompe a execução se ocorrer qualquer erro
set -e

echo "🚀 1/5 Verificando o ambiente..."

# Ajuste do Java 21 (descomente a linha abaixo se necessário)
# export JAVA_HOME="/caminho/para/o/seu/java-21"

echo "🔄 2/5 Sincronizando arquivos Web (da pasta www) com o Android..."
npx cap sync android

echo "🧹 3/5 Limpando compilações antigas e gerando novo APK..."
cd android
./gradlew clean assembleDebug
cd ..

# Definição dos nomes e caminhos
ORIGEM_APK="android/app/build/outputs/apk/debug/app-debug.apk"
DESTINO_APK="app-debug.apk"

echo "🔄 4/5 Sobrescrevendo o arquivo $DESTINO_APK na raiz..."
if [ -f "$ORIGEM_APK" ]; then
    cp -f "$ORIGEM_APK" ./"$DESTINO_APK"
    echo "   ✅ Arquivo $DESTINO_APK atualizado na raiz!"
else
    echo "   ❌ Erro: O arquivo APK não foi encontrado em $ORIGEM_APK"
    exit 1
fi

echo "🔍 5/5 Preparando alterações para o Git e enviando..."
git add .
git add -f "$DESTINO_APK"

MENSAGEM="Atualização de tema, Edge-to-Edge e APK ($DESTINO_APK) em: $(date +'%d/%m/%Y às %H:%M')"
git commit -m "$MENSAGEM" || echo "ℹ️ Nenhuma alteração pendente para salvar."

git push

echo "=================================================="
echo "🎉 Sucesso! O arquivo $DESTINO_APK foi gerado com as suas alterações reais!"
echo "=================================================="