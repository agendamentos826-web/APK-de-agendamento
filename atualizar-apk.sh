#!/bin/bash

# ==============================================================================
# SCRIPT PARA GERAR E SOBRESCREVER O APK NO PROJETO E NO GITHUB
# ==============================================================================

# Para a execução se ocorrer qualquer erro
set -e

echo "🚀 1/6 Verificando ambiente..."

# Ajuste do Java 21 (descomente a linha abaixo se for necessário fixar o caminho)
# export JAVA_HOME="/caminho/para/o/seu/java-21"

echo "📦 2/6 Sincronizando arquivos Web com o Android..."
npx cap copy android

echo "🧹 3/6 Limpando compilações anteriores e gerando novo APK..."
cd android
# O comando 'clean' apaga os arquivos velhos para garantir que o novo APK seja criado do zero
./gradlew clean assembleDebug
cd ..

# Definição dos nomes e caminhos
ORIGEM_APK="android/app/build/outputs/apk/debug/app-debug.apk"
DESTINO_APK="app-debug.apk"

echo "🔄 4/6 Sobrescrevendo o arquivo $DESTINO_APK na raiz do projeto..."
if [ -f "$ORIGEM_APK" ]; then
    # O parâmetro -f (force) obriga o sistema a sobrescrever o arquivo existente
    cp -f "$ORIGEM_APK" ./"$DESTINO_APK"
    echo "   ✅ Arquivo $DESTINO_APK sobrescrito com sucesso!"
else
    echo "   ❌ Erro: O APK não foi encontrado em $ORIGEM_APK"
    exit 1
fi

echo "🔍 5/6 Preparando a nova versão para o Git..."
# Adiciona todos os arquivos do projeto
git add .

# Força a atualização do APK sobrescrito no Git
git add -f "$DESTINO_APK"

# Registra a alteração com data e hora
MENSAGEM="Sobrescrito $DESTINO_APK em: $(date +'%d/%m/%Y às %H:%M')"
git commit -m "$MENSAGEM" || echo "ℹ️ Nenhuma alteração pendente para salvar."

echo "⬆️ 6/6 Enviando a versão atualizada para o GitHub..."
git push

echo "=================================================="
echo "🎉 Sucesso! O arquivo $DESTINO_APK foi totalmente atualizado e sobrescrito!"
echo "=================================================="