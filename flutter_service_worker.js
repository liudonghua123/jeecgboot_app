'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"/manifest.json": "e5f45f50aef780679d64589f70efe980",
"/icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"/icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"/assets/AssetManifest.json": "1903154ba7b3b5163b8f7bfd4bc1e435",
"/assets/LICENSE": "c56d648f71f41ae1d867b7c4d3c44183",
"/assets/assets/logo.png": "4231452532b8e057f50fb9457b8312b2",
"/assets/assets/config.yaml": "1d02a20bca886b2b203f3c697a6c8528",
"/assets/assets/001-boy.png": "5145708211d1de9ae5652d9abac36850",
"/assets/assets/men_wearing_jacket.gif": "c5738331b11f3db2db8ad0b3776966a7",
"/assets/assets/loveyou-cut.mp4": "2034a05cb3cd5699330da850d9857938",
"/assets/assets/space_demo.flr": "5403c701d61b4da9df509b8dc29d49c4",
"/assets/assets/fine-cut.mp3": "a6838cc2a4dda6b41ca2685d8aeff679",
"/assets/assets/alucard.jpg": "13901053e0bb41ffd954addd234848f6",
"/assets/packages/fancy_dialog/assets/gif3.gif": "9756c2a05e2dd85309fe4b3bc5d62357",
"/assets/packages/fancy_dialog/assets/gif2.gif": "10511cc7d2aebde489ded7ecd56344b8",
"/assets/packages/fancy_dialog/assets/gif5.gif": "98be0097a3eac5fb4e5c76fb271caaf1",
"/assets/packages/fancy_dialog/assets/gif6.gif": "da048fce2f9995f25fce360ec511567d",
"/assets/packages/fancy_dialog/assets/gif1.gif": "c5738331b11f3db2db8ad0b3776966a7",
"/assets/packages/fancy_dialog/assets/gif4.gif": "1785ef046094bead949e9afc4ad1445a",
"/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"/assets/packages/progress_dialog/assets/double_ring_loading_io.gif": "e5b006904226dc824fdb6b8027f7d930",
"/assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"/assets/FontManifest.json": "01700ba55b08a6141f33e168c4a6c22f",
"/main.dart.js": "225b6298299c83860eee506647780c92",
"/index.html": "d3033a757e71e468ce1850272b274cc3"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
