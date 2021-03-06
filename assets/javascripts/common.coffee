requirejs.config
  urlArgs: "b=#{(new Date()).getTime()}"
  paths:
    jquery: 'vendor/jquery'
    underscore: 'vendor/lodash.min'
    backbone: 'vendor/backbone-extended'
    leaflet: 'vendor/leaflet-src'
    leaflet_draw: 'vendor/leaflet.draw-src'
    leaflet_markercluster: 'vendor/leaflet.markercluster-src'
    leaflet_heatmap: 'vendor/heatmap-leaflet'
  shim:
    'leaflet_draw':
      deps: ['leaflet']
    'leaflet_markercluster':
      deps: ['leaflet']
    'leaflet_heatmap':
      deps: ['leaflet']