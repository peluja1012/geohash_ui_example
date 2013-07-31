define ['underscore', 'backbone', 'berico/geohash_widget'], (_, Backbone, GeohashWidget) ->

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
          max = 0
          for key, i in Object.keys(geoFacetsObj)
            points = []
            # Calculate the max value of the highest level geohash dataset
            if i is 0
              maxTerm = _.max geoFacetsObj[key].terms, (term) -> term.count
              max = maxTerm.count
            for term in geoFacetsObj[key].terms
              points.push {lat:term.lat_lng.lat, lon:term.lat_lng.lng, value:term.count}
            pointsArray.push {max: max, data: points}
            
          console.log pointsArray
          @widget.resetData(pointsArray)

      @widget.bbox(55, 40, 50, 20)
      @widget.deleteBbox()
