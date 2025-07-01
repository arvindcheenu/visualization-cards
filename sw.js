// Service Worker for Visualization Cards PWA
const CACHE_NAME = 'visualization-cards-v1.0.0';
const DATA_CACHE_NAME = 'visualization-cards-data-v1.0.0';
// Files to cache for offline functionality
const FILES_TO_CACHE = [
  './',
  './index.html',
  './manifest.json',
  './sw.js',
  'https://cdn.tailwindcss.com',
  'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css',
  'https://cdnjs.cloudflare.com/ajax/libs/medium-zoom/1.1.0/medium-zoom.min.js',
];
// Install event - cache core files
self.addEventListener('install', (event) => {
  console.log('[ServiceWorker] Install');
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      console.log('[ServiceWorker] Pre-caching offline page');
      return cache.addAll(FILES_TO_CACHE);
    })
  );
  self.skipWaiting();
});
// Activate event - clean up old caches
self.addEventListener('activate', (event) => {
  console.log('[ServiceWorker] Activate');
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheName !== CACHE_NAME && cacheName !== DATA_CACHE_NAME) {
            console.log('[ServiceWorker] Removing old cache', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
  self.clients.claim();
});
// Fetch event - serve cached content when offline
self.addEventListener('fetch', (event) => {
  console.log('[ServiceWorker] Fetch', event.request.url);
  // Handle card images with cache-first strategy
  if (event.request.url.includes('/cards/')) {
    event.respondWith(
      caches.open(DATA_CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response) {
            console.log('[ServiceWorker] Serving card image from cache');
            return response;
          }
          return fetch(event.request).then((networkResponse) => {
            if (networkResponse.status === 200) {
              cache.put(event.request.url, networkResponse.clone());
            }
            return networkResponse;
          }).catch(() => {
            // Return a placeholder image if offline and not cached
            return new Response(
              `<svg xmlns="http://www.w3.org/2000/svg" width="300" height="480" viewBox="0 0 300 480">
                <rect width="300" height="480" fill="#e5e7eb"/>
                <text x="150" y="240" text-anchor="middle" fill="#6b7280" font-family="sans-serif" font-size="14">
                  Card Image
                </text>
                <text x="150" y="260" text-anchor="middle" fill="#9ca3af" font-family="sans-serif" font-size="12">
                  (Offline)
                </text>
              </svg>`,
              {
                headers: {
                  'Content-Type': 'image/svg+xml'
                }
              }
            );
          });
        });
      })
    );
    return;
  }
  // Handle external CDN resources
  if (event.request.url.includes('cdn.tailwindcss.com') || 
      event.request.url.includes('cdnjs.cloudflare.com')) {
    event.respondWith(
      caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response) {
            return response;
          }
          return fetch(event.request).then((networkResponse) => {
            if (networkResponse.status === 200) {
              cache.put(event.request.url, networkResponse.clone());
            }
            return networkResponse;
          }).catch(() => {
            // Return minimal fallback CSS if CDN is unavailable
            if (event.request.url.includes('tailwindcss')) {
              return new Response(
                '/* Tailwind CSS fallback */\n.hidden { display: none !important; }\n.flex { display: flex; }\n.block { display: block; }',
                { headers: { 'Content-Type': 'text/css' } }
              );
            }
            if (event.request.url.includes('font-awesome')) {
              return new Response(
                '/* Font Awesome fallback */\n.fas:before { content: "●"; }',
                { headers: { 'Content-Type': 'text/css' } }
              );
            }
          });
        });
      })
    );
    return;
  }
  // Default strategy for other requests
  event.respondWith(
    caches.match(event.request).then((response) => {
      // Return cached version or fetch from network
      return response || fetch(event.request).catch(() => {
        // If we're offline and requesting the root, return the cached index
        if (event.request.url.endsWith('/') || event.request.url.includes('index.html')) {
          return caches.match('./index.html');
        }
      });
    })
  );
});
// Background sync for saving data
self.addEventListener('sync', (event) => {
  console.log('[ServiceWorker] Background sync', event.tag);
  if (event.tag === 'background-sync') {
    event.waitUntil(
      // Handle any background sync tasks here
      console.log('[ServiceWorker] Background sync completed')
    );
  }
});
// Handle push notifications (if needed in the future)
self.addEventListener('push', (event) => {
  console.log('[ServiceWorker] Push received');
  const options = {
    body: event.data ? event.data.text() : 'New update available!',
    icon: 'icons/icon-192x192.png',
    badge: 'icons/icon-72x72.png',
    vibrate: [100, 50, 100],
    data: {
      dateOfArrival: Date.now(),
      primaryKey: 1
    }
  };
  event.waitUntil(
    self.registration.showNotification('Visualization Cards', options)
  );
});
// Handle notification clicks
self.addEventListener('notificationclick', (event) => {
  console.log('[ServiceWorker] Notification click received');
  event.notification.close();
  event.waitUntil(
    clients.openWindow('./')
  );
});
// Handle app shortcuts
self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
});
// Periodically clean up old cached data
setInterval(() => {
  caches.open(DATA_CACHE_NAME).then((cache) => {
    cache.keys().then((requests) => {
      if (requests.length > 100) { // Limit cache size
        // Remove oldest cached items
        const oldRequests = requests.slice(0, 20);
        oldRequests.forEach((request) => {
          cache.delete(request);
        });
        console.log('[ServiceWorker] Cleaned up old cached data');
      }
    });
  });
}, 300000); // Run every 5 minutes