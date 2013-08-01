exports.config =
  modules: ['lint', 'server', 'require', 'minify', 'live-reload', 'combine', 'server-reload', 'testem-require', 'require-library-package']
  server:
    port:3005
  libraryPackage:
    globalName: "GeoHashHeatMap"
    name: "berico.geoHashHeatMap.js"
    main: "berico/geohash_widget"
    removeDependencies: ["leaflet", "leaflet_heatmap","leaflet_draw"]
