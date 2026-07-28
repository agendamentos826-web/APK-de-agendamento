#!/bin/bash

# ==============================================================================
# SCRIPT COMPLETO DE COMPILAÇÃO, SINCRONIZAÇÃO E ENVIO DO APK
# ==============================================================================

# Para a execução do script caso ocorra qualquer erro intermediário
set -e

echo "🚀 1/6 Verificando o ambiente de execução..."

# Ajuste do Java 21 (descomente a linha abaixo se for necessário fixar o caminho)
# export JAVA_HOME="/caminho/para/o/seu/java-21"

echo "🔄 2/6 Sincronizando arquivos Web e Configurações (Capacitor Sync)..."
# O 'cap sync' executa 'copy' (copia a pasta www e capacitor.config.json) 
# e 'update' (atualiza os plugins nativos do Android)
npx cap sync android

echo "🧹 3/6 Limpando compilações anteriores e gerando novo APK..."
cd android
# O comando 'clean' apaga arquivos em cache e 'assembleDebug' compila do zero
./gradlew clean assembleDebug
cd ..

# Definição dos nomes e caminhos do arquivo final
ORIGEM_APK="android/app/build/outputs/apk/debug/app-debug.apk"
DESTINO_APK="app-debug.apk"

echo "📋 4/6 Sobrescrevendo o arquivo $DESTINO_APK na raiz..."
if [ -f "$ORIGEM_APK" ]; then
    # O parâmetro -f (force) garante a substituição completa do arquivo anterior
    cp -f "$ORIGEM_APK" ./"$DESTINO_APK"
    echo "   ✅ Arquivo $DESTINO_APK sobrescrito com sucesso!"
else
    echo "   ❌ Erro: O arquivo compilado não foi encontrado em $ORIGEM_APK"
    exit 1
fi

echo "🔍 5/6 Preparando os arquivos para envio no Git..."
# Adiciona todas as modificações do projeto (incluindo o capacitor.config.json)
git add .

# Força a inclusão do arquivo APK atualizado
git add -f "$DESTINO_APK"

# Cria a mensagem de alteração com data e hora atual do sistema
MENSAGEM="Versão atualizada ($DESTINO_APK) em: $(date +'%d/%m/%Y às %H:%M')"
git commit -m "$MENSAGEM" || echo "ℹ️ Nenhuma alteração pendente para salvar."

echo "⬆️ 6/6 Enviando todas as atualizações para o GitHub..."
git push

echo "=================================================="
echo "🎉 Sucesso! O seu APK e as configurações foram atualizados no GitHub!"
echo "=================================================="