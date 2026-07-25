package com.barbearialucasborges.app;

import android.os.Bundle;
import android.webkit.WebSettings;
import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // DESATIVA O MODO ESCURO FORÇADO DO ANDROID
        // Isto impede que o Android pinte a tela de preto e obriga o WebView 
        // a respeitar as cores originais do teu projeto.
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q) {
            this.bridge.getWebView().getSettings().setForceDark(WebSettings.FORCE_DARK_OFF);
        }
    }
}
