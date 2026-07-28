package com.barbearia.lucasborges;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.webkit.PermissionRequest;
import android.webkit.WebChromeClient;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {
    private static final int CODIGO_PERMISSAO_MIC = 1001;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // 1. Solicita a permissão nativa de microfone ao sistema Android se ainda não foi concedida
        solicitarPermissaoMicrofoneNativa();

        // 2. Autoriza a WebView do Capacitor a repassar o áudio para o JavaScript
        configurarWebViewParaMicrofone();
    }

    private void solicitarPermissaoMicrofoneNativa() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO)
                != PackageManager.PERMISSION_GRANTED) {

            ActivityCompat.requestPermissions(
                this,
                new String[]{Manifest.permission.RECORD_AUDIO},
                CODIGO_PERMISSAO_MIC
            );
        }
    }

    private void configurarWebViewParaMicrofone() {
        if (this.bridge != null && this.bridge.getWebView() != null) {
            this.bridge.getWebView().setWebChromeClient(new WebChromeClient() {
                @Override
                public void onPermissionRequest(final PermissionRequest request) {
                    // Executa na thread principal para autorizar a requisição de mídia da página Web
                    runOnUiThread(() -> request.grant(request.getResources()));
                }
            });
        }
    }
}
