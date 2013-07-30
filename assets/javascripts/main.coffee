require
  urlArgs: "b=#{(new Date()).getTime()}"
  paths:
    jquery: 'vendor/jquery'
    underscore: 'vendor/lodash.min'
    backbone: 'common/util/backbone-extended'
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
  , ['app/sample_geohash_view']
  , (SampleGeohashView) ->
    view = new SampleGeohashView({el:'#mapContainer'})
    #view.render('body')