package com.barbearialucasborges.app;

import android.os.Bundle;
import android.webkit.PermissionRequest;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        WebView webView = this.bridge.getWebView();

        // =================================================================
        // 1. DESATIVA O MODO ESCURO FORÇADO (ANDROID 10, 11 E 12)
        // =================================================================
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q) {
            webView.getSettings().setForceDark(WebSettings.FORCE_DARK_OFF);
        }

        // =================================================================
        // 2. DESATIVA O ESCURECIMENTO ALGORÍTMICO (ANDROID 13 OU SUPERIOR)
        // =================================================================
        try {
            WebSettings.class.getMethod("setAlgorithmicDarkeningAllowed", boolean.class)
                    .invoke(webView.getSettings(), false);
        } catch (Exception ignored) {
            // Executado em versões do Android onde o método não existe
        }

        // =================================================================
        // 3. AUTORIZAÇÃO E MANUTENÇÃO CONTÍNUA DO MICROFONE NO WEBVIEW
        // =================================================================
        webView.setWebChromeClient(new WebChromeClient() {
            @Override
            public void onPermissionRequest(final PermissionRequest request) {
                // Concede acesso contínuo aos recursos de áudio solicitados pelo HTML/JS
                runOnUiThread(() -> request.grant(request.getResources()));
            }
        });
    }
}
