require ['../common'], ->
  require ['demo/sample_geohash_view'], (SampleGeohashView) ->
    new SampleGeohashView({el:'#mapContainer'})
