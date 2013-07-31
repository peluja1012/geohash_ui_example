define ['backbone', 'berico/geohash_widget'], (Backbone, GeohashWidget) ->

  class SampleGeohashView extends Backbone.View

    initialize: (opts) ->
      @widget = new GeohashWidget.Widget()
      @widget.on 'bboxDrawn', (data) ->
        console.log "it was drawn!!!", data

      @widget.on 'bboxDeleted', (data) ->
        console.log "it was deleted!!!"

      @render()
      @fetchData()

    render: ->
      @renderTemplate "sample_geohash_view", {}

    fetchData: ->
      opts =
        imagePath: "/img/leaflet"
        mapUrl: "https://gmdemo.keyhole.com"
        el: 'map'

      @widget.draw(opts)
      $.ajax
        url: '/geohashdata'
        success: (data) =>
          pointsArray = []
          geoFacetsObj = data.docFacetResults.facets
          for key in Object.keys(geoFacetsObj)
            points = []
            for term in geoFacetsObj[key].terms
              points.push {lat:term.lat_lng.lat, lon:term.lat_lng.lng, value:term.count}
            pointsArray.push points
            
          console.log pointsArray
          @widget.resetData(pointsArray)

      @widget.bbox(55, 40, 50, 20)
      @widget.deleteBbox()
