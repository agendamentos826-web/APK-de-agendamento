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
        // 1. BLINDAGEM DO SEU DATA-THEME (Impede o Android de estragar cores)
        // =================================================================
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q) {
            webView.getSettings().setForceDark(WebSettings.FORCE_DARK_OFF);
        }

        try {
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.TIRAMISU) {
                WebSettings.class.getMethod("setAlgorithmicDarkeningAllowed", boolean.class)
                        .invoke(webView.getSettings(), false);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // =================================================================
        // 2. CORREÇÃO DO MICROFONE (Permissão contínua)
        // =================================================================
        webView.setWebChromeClient(new WebChromeClient() {
            @Override
            public void onPermissionRequest(final PermissionRequest request) {
                runOnUiThread(() -> {
                    try {
                        request.grant(request.getResources());
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                });
            }
        });
    }
}
