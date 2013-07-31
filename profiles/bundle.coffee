exports.config =
  modules: ['lint', 'require', 'minify']
  watch:
    exclude:[/\/demo\//, "javascripts/main.coffee"]
    compiledDir:"dist"
  require:
    optimize:
      overrides: (runConfig) ->
        runConfig.insertRequire = null
        runConfig.include = ["berico/geohash_widget"]
        runConfig.name = "berico/geohash_widget"
        runConfig.exclude = ["leaflet", "leaflet_heatmap","leaflet_draw"]
        runConfig.out = "dist/berico.geoHashHeatMap.js"
        runConfig.wrap =
          endFile: "assets/javascripts/berico/end.frag"
  copy:
    extensions: ["frag","js","css","png","jpg","jpeg","gif","html","eot","svg","ttf","woff","otf","yaml","kml","ico","htc","htm","json","txt","xml","xsd","map","md"]
