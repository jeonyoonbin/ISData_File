'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "d81fcd1e78c2afb1cc4196b2c160c4bf",
"assets/assets/animat-responsive-color.gif": "43c68fbe91e9b8a83464d04ddc357fb5",
"assets/assets/apple_icon_32.png": "cd698fc10fa1ab630671a91a02555c40",
"assets/assets/BI_1.png": "a4a13f1571f223f8755a999e3129433e",
"assets/assets/BI_5.png": "98b06947e367c218ee9d64b2d60fc097",
"assets/assets/BI_6.png": "9053cbceb7874e31a75f23830bf27b7f",
"assets/assets/btnAppAlertnotice_000.png": "71c7286ff095b815b040f5a48e67c7ae",
"assets/assets/btnAppAlertnotice_001.png": "e934b5afe75555f7fb87575531e34caa",
"assets/assets/btnAppAlertnotice_100.png": "6bc3765982ee5e6cd9efd4e4296eca0f",
"assets/assets/btnAppAlertnotice_101.png": "2bbc3743d36a18d59614c0c808155837",
"assets/assets/btnAppAlertnotice_200.png": "dc19237773a0a1585afc7715cace18e4",
"assets/assets/btnAppAlertnotice_201.png": "3d2c7d5079329cfe8a1ca9cfcfbca808",
"assets/assets/daeguro_icon_32.png": "7d56d047296879a6a0bccace8a8745aa",
"assets/assets/editor.html": "02312e7a1e9edb0c9b4a5d832eadcb41",
"assets/assets/empty_menu.png": "d11e8b5488486811419a6487f61f9a97",
"assets/assets/fonts/font_roboto_bold.ttf": "e07df86cef2e721115583d61d1fb68a6",
"assets/assets/fonts/font_roboto_regular.ttf": "11eabca2251325cfc5589c9c6fb57b46",
"assets/assets/fonts/NotoSansKR-Regular.otf": "913f146b0200b19b17eb4de8b4427a9c",
"assets/assets/google_icon_32.png": "cf5e6630ae753609af1a8106b2eb8861",
"assets/assets/image-resize.min.js": "c6329b8b4f764d9983d291c02ac2389d",
"assets/assets/jquery.min.js": "9ac39dc31635a363e377eda0f6fbe03f",
"assets/assets/kakao_icon_32.png": "17ffe8d48c72e9348c3937be25ae18bc",
"assets/assets/logo.png": "cf0f6e83eedd8fcf8ff8e844cac548fb",
"assets/assets/naver_icon_32.png": "4ce9b2838256207b3401a446e1ec7794",
"assets/assets/quill.bubble.css": "da771fde1afdc1549ed61f2e111211b8",
"assets/assets/quill.js": "405d190bcde9746579f8e6fae5dc5cdf",
"assets/assets/quill.snow.css": "e91875a3a958d4cd53dab04c99c6964f",
"assets/assets/serverInfo.txt": "ae8c867154c72c576eaf0c8a3b70d029",
"assets/assets/view.html": "3cfe193e645e65176871d4c52a835791",
"assets/FontManifest.json": "6c8485c2576b3ded3a533c56e2df3f4c",
"assets/fonts/MaterialIcons-Regular.otf": "4e6447691c9509f7acdbf8a931a85ca1",
"assets/NOTICES": "fe66dc3b7bab5a0e017253efd5eba88e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "b43c29fd954adbb003f0207a488935af",
"/": "b43c29fd954adbb003f0207a488935af",
"main.dart.js": "51ec00cdb371c24d2733913823c09a15",
"manifest.json": "3d178707007b3b60d91745e0464910a0",
"version.json": "da6be7110a6130989fd7332a7a03cf8d"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
