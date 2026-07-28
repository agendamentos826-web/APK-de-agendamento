package com.barbearia.lucasborges;

import android.Manifest;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
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

        // 1. Força a cor #485460 diretamente na janela nativa do Android
        configurarStatusBarNativa();

        // 2. Solicita a permissão nativa de microfone ao sistema Android
        solicitarPermissaoMicrofoneNativa();

        // 3. Autoriza a WebView do Capacitor a repassar o áudio para o JavaScript
        configurarWebViewParaMicrofone();
    }

    /**
     * Define a cor da barra de estado nativa como #485460
     * e ajusta o contraste dos ícones (relojó, bateria, Wi-Fi).
     */
    private void configurarStatusBarNativa() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Window window = getWindow();
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            
            // Define explicitamente a cor #485460 na barra superior
            window.setStatusBarColor(Color.parseColor("#485460"));

            // Ajusta o estilo dos ícones para ficarem brancos
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                View decorView = window.getDecorView();
                int flags = decorView.getSystemUiVisibility();
                // Desativa os ícones escuros para forçar ícones claros/brancos
                flags &= ~View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
                decorView.setSystemUiVisibility(flags);
            }
        }
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
