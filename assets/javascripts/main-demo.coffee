require ['./common'], ->
  require ['app/sample_geohash_view'], (SampleGeohashView) ->
    new SampleGeohashView({el:'#mapContainer'})
