'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "index.html": "d3033a757e71e468ce1850272b274cc3",
"/": "d3033a757e71e468ce1850272b274cc3",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"assets/packages/progress_dialog/assets/double_ring_loading_io.gif": "e5b006904226dc824fdb6b8027f7d930",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "2bca5ec802e40d3f4b60343e346cedde",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "2aa350bd2aeab88b601a593f793734c0",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "5a37ae808cf9f652198acde612b5328d",
"assets/packages/fancy_dialog/assets/gif6.gif": "da048fce2f9995f25fce360ec511567d",
"assets/packages/fancy_dialog/assets/gif4.gif": "1785ef046094bead949e9afc4ad1445a",
"assets/packages/fancy_dialog/assets/gif2.gif": "10511cc7d2aebde489ded7ecd56344b8",
"assets/packages/fancy_dialog/assets/gif5.gif": "98be0097a3eac5fb4e5c76fb271caaf1",
"assets/packages/fancy_dialog/assets/gif3.gif": "9756c2a05e2dd85309fe4b3bc5d62357",
"assets/packages/fancy_dialog/assets/gif1.gif": "c5738331b11f3db2db8ad0b3776966a7",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"assets/assets/fine.mp3": "92e3b95fbff6b9139cc40bbfc313c92d",
"assets/assets/Nunito.ttf": "65bb0a158ee1967292ee4d11079d45ae",
"assets/assets/logo.png": "4231452532b8e057f50fb9457b8312b2",
"assets/assets/fine-cut.mp3": "a6838cc2a4dda6b41ca2685d8aeff679",
"assets/assets/men_wearing_jacket.gif": "c5738331b11f3db2db8ad0b3776966a7",
"assets/assets/space_demo.flr": "5403c701d61b4da9df509b8dc29d49c4",
"assets/assets/alucard.jpg": "13901053e0bb41ffd954addd234848f6",
"assets/assets/001-boy.png": "5145708211d1de9ae5652d9abac36850",
"assets/assets/loveyou.mp4": "6d9a77171b768a81b4a32c6f624b512c",
"assets/assets/loveyou-cut.mp4": "2034a05cb3cd5699330da850d9857938",
"assets/assets/ling.jpg": "f26b1bca347ee11e2aa6f1e53a92d3a2",
"assets/FontManifest.json": "18eda8e36dfa64f14878d07846d6e17f",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/AssetManifest.json": "84e75293bbbcfd469196adb891acfca0",
"assets/LICENSE": "dfaab7fa8b96d562c5858d59282a7ee8",
"assets/config.yaml": "1d02a20bca886b2b203f3c697a6c8528",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"main.dart.js": "21d025c50c9ffb3fa77b51c722f00c09",
"manifest.json": "e5f45f50aef780679d64589f70efe980"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"/",
"index.html",
"assets/LICENSE",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(CORE);
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
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // If the URL is not the the RESOURCE list, skip the cache.
  if (!RESOURCES[key]) {
    return event.respondWith(fetch(event.request));
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

