#!/bin/bash

# Define o Java 21 automaticamente para evitar erros de versão do Gradle
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64

echo "Passo 1: A sincronizar o código para o Android..."
npx cap sync android

echo "Passo 2: A compilar o novo APK. Isto pode demorar um pouco..."
cd android
./gradlew assembleDebug
cd ..

echo "Passo 3: A preparar o ficheiro para o GitHub..."
git add -f android/app/build/outputs/apk/debug/app-debug.apk

echo "Passo 4: A gravar e a enviar para a nuvem..."
git commit -m "Atualização automática da aplicação"
git push

echo "Sucesso! O seu novo APK já está no GitHub pronto a descarregar!"