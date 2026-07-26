const CACHE_NAME = 'barbearia-lb-v1';
const ASSETS_TO_CACHE = [
    '/', // A página inicial (Dashboard)
    '/manifest.json',
    
    // Os teus ícones (para garantir que carregam offline)
    '/static/icons/icon-192.png',
    '/static/icons/icon-512.png',
    '/static/icons/maskable-icon-192.png',
    '/static/icons/maskable-icon-512.png',
    
    // Adicione aqui outros arquivos CSS ou JS se souber o caminho, 
    // por exemplo: '/static/css/style.css'
];

// 1. INSTALAÇÃO: Armazena os arquivos estáticos iniciais
self.addEventListener('install', (event) => {
    event.waitUntil(
        caches.open(CACHE_NAME)
        .then((cache) => {
            console.log('Service Worker: A fazer cache dos arquivos estáticos');
            return cache.addAll(ASSETS_TO_CACHE);
        })
    );
});

// 2. ATIVAÇÃO: Limpa caches antigos quando mudas a versão (v1 -> v2)
self.addEventListener('activate', (event) => {
    event.waitUntil(
        caches.keys().then((keyList) => {
            return Promise.all(keyList.map((key) => {
                if (key !== CACHE_NAME) {
                    console.log('Service Worker: A remover cache antigo', key);
                    return caches.delete(key);
                }
            }));
        })
    );
    return self.clients.claim();
});

// 3. FETCH (INTERCEPTAR PEDIDOS): Estratégia Rede Primeiro (Network First)
self.addEventListener('fetch', (event) => {
    // Apenas para pedidos GET (páginas e arquivos)
    if (event.request.method !== 'GET') return;

    event.respondWith(
        fetch(event.request)
            .then((response) => {
                // Se a internet funcionar:
                // 1. Clona a resposta (para poder guardar uma cópia)
                const responseClone = response.clone();
                
                // 2. Abre o cache e guarda a versão mais nova
                caches.open(CACHE_NAME).then((cache) => {
                    cache.put(event.request, responseClone);
                });

                // 3. Retorna a resposta original para o navegador
                return response;
            })
            .catch(() => {
                // Se estiver OFFLINE:
                // Tenta encontrar o arquivo no cache
                return caches.match(event.request)
                    .then((cachedResponse) => {
                        if (cachedResponse) {
                            return cachedResponse;
                        }
                        // Opcional: Aqui podes retornar uma página de "Você está offline" personalizada
                        //teste
                    });
            })
    );
});
