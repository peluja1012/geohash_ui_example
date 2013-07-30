define ['backbone', './geohash_widget'], (Backbone, GeohashWidget) ->

  class SampleGeohashView extends Backbone.View

    initialize: (opts) ->
      @widget = new GeohashWidget()
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
          terms = data.geoHashData
          points = []
          count = 0
          for term in terms
            if count > 2
              points.push {lat:term.term.lat, lon:term.term.lng, value:term.count}
            count++

          @widget.resetData([points, points, points, points, points])

      @widget.bbox(55, 40, 50, 20)
      @widget.deleteBbox()
