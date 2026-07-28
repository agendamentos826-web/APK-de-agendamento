#!/bin/bash

# ==============================================================================
# SCRIPT AUTOMÁTICO COM GARANTIA DE CONFIGURAÇÃO (CAPACITOR + GRADLE)
# ==============================================================================

# Interrompe a execução se ocorrer qualquer erro
set -e

echo "🚀 1/7 Verificando o ambiente..."

# Ajuste do Java 21 (descomente a linha abaixo se necessário)
# export JAVA_HOME="/caminho/para/o/seu/java-21"

echo "⚙️ 2/7 Blindando e gravando o capacitor.config.json com tom claro (#485460)..."

# Escreve diretamente o arquivo de configuração com as cores corretas
cat << 'EOF' > capacitor.config.json
{
  "appId": "com.barbearia.lucasborges",
  "appName": "Agendamentos LB",
  "webDir": "www",
  "bundledWebRuntime": false,
  "backgroundColor": "#485460",
  "android": {
    "allowMixedContent": true,
    "captureInput": true,
    "webContentsDebuggingEnabled": true
  },
  "plugins": {
    "StatusBar": {
      "overlaysWebView": false,
      "style": "LIGHT",
      "backgroundColor": "#485460"
    }
  }
}
EOF

echo "   ✅ Configuração atualizada com sucesso na raiz!"

echo "📦 3/7 Sincronizando arquivos Web e Configurações com o Android..."
npx cap sync android

echo "🧹 4/7 Limpando compilações antigas e gerando novo APK..."
cd android
./gradlew clean assembleDebug
cd ..

# Definição dos nomes e caminhos
ORIGEM_APK="android/app/build/outputs/apk/debug/app-debug.apk"
DESTINO_APK="app-debug.apk"

echo "🔄 5/7 Sobrescrevendo o arquivo $DESTINO_APK na raiz..."
if [ -f "$ORIGEM_APK" ]; then
    cp -f "$ORIGEM_APK" ./"$DESTINO_APK"
    echo "   ✅ Arquivo $DESTINO_APK atualizado na raiz!"
else
    echo "   ❌ Erro: O arquivo APK não foi encontrado em $ORIGEM_APK"
    exit 1
fi

echo "🔍 6/7 Preparando alterações para o Git..."
git add .
git add -f "$DESTINO_APK"

MENSAGEM="Atualização de tema e APK ($DESTINO_APK) em: $(date +'%d/%m/%Y às %H:%M')"
git commit -m "$MENSAGEM" || echo "ℹ️ Nenhuma alteração pendente para salvar."

echo "⬆️ 7/7 Enviando atualizações para o GitHub..."
git push

echo "=================================================="
echo "🎉 Sucesso! O arquivo $DESTINO_APK e as configurações foram atualizados!"
echo "=================================================="