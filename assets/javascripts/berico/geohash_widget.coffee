define ['leaflet', 'leaflet_draw', 'leaflet_heatmap'], ->

  _determineGeohashPrecision = (lat_diff, lng_diff) ->
    # These values are calculated by initially diving 360 by 8 (for lngs) and 180 by 4 (for lats)
    # Then for lats, divide the result by 8 and for lngs divide by 4
    # Then alternate: for lats, divide the result by 4 and for lngs divide by 8

    if lng_diff < 0.04394
      lng_precision = 6
    else if lng_diff < 0.3515
      lng_precision = 5
    else if lng_diff < 1.406
      lng_precision = 4
    else if lng_diff < 11.25
      lng_precision = 3
    else if lng_diff < 45
      lng_precision = 2
    else
      lng_precision = 1

    if lat_diff < 0.04394
      lat_precision = 6
    else if lat_diff < 0.1757
      lat_precision = 5
    else if lat_diff < 1.40625
      lat_precision = 4
    else if lat_diff < 5.625
      lat_precision = 3
    else if lat_diff < 45
      lat_precision = 2
    else
      lat_precision = 1

    Math.min(lat_precision,lng_precision)

  class GeoHashWidget

    constructor: ->
      @map = null
      @handlers = {}
      @bboxLayer = null
      @geoHashDataSets =
        set_1: null
        set_2: null
        set_3: null
        set_4: null
        set_5: null

      # feature group where bboxes are added
      @drawnItems = null

    on: (name, callback) ->
      unless @handlers[name]?
        @handlers[name] = []

      @handlers[name].push callback

    resetData: (dataSets) ->
      for dataSet, i in dataSets
        @geoHashDataSets["set_#{i+1}"] = dataSet

      @_populateHeatmapData()

    bbox: (north, east, south, west) ->
      rectOpts =
        stroke: true
        color: '#f06eaa'
        weight: 4
        opacity: 0.5
        fill: true
        fillColor: null #same as color by default
        fillOpacity: 0.2
        clickable: true

      northEast = new L.LatLng(north, east)
      southWest = new L.LatLng(south, west)
      bounds = new L.LatLngBounds(southWest, northEast)
      rect = new L.Rectangle(bounds, rectOpts)
      rect.addTo(@drawnItems)

      @bboxLayer = rect
      data =
        northEast:
          lat: north
          lng: east
        southWest:
          lat: south
          lng: west

      @_publish 'bboxDrawn', data


    deleteBbox: ->
      if @bboxLayer?
        console.log "deleted removing layer"
        @drawnItems.removeLayer(@bboxLayer)
        @_publish 'bboxDeleted'
        @bboxLayer = null

    ###
    # Options:
    # imagePath: optional. The path to the folder where the leaflet images are located
    # mapUrl:    required. URL of map tile service. Assumes the use of a GEE Fusion Map Server.
    # el:        required. The id of a DIV element
    ###
    draw: (opts) ->
      unless opts.el?
        throw new Error('Please provide a value for the [el] option')
      unless opts.mapUrl?
        throw new Error('Please provide a value for the [mapUrl] option')

      if opts.imagePath?
        L.Icon.Default.imagePath = "#{opts.imagePath}"

      @heatmapLayer = L.TileLayer.heatMap({
          # radius could be absolute or relative
          # absolute: radius in meters, relative: radius in pixels
          radius:
            value: 20
            absolute: false
          opacity: 0.8
          gradient:
            0.45: "rgb(0,0,255)"
            0.55: "rgb(0,255,255)"
            0.65: "rgb(0,255,0)"
            0.95: "yellow"
            1.0: "rgb(255,0,0)"
      })

      @map = L.map(opts.el, {layers:[@heatmapLayer]}).setView([0, 0], 1)

      overlayMaps = {}
      baseMaps = {}

      overlayMaps.heat = @heatmapLayer

      if geeServerDefs?
        console.log geeServerDefs
        for layer, i in geeServerDefs.layers
          channel = layer.id
          requestType = layer.requestType
          version = layer.version
          label = layer.label
          tileLayer = L.tileLayer("#{opts.mapUrl}/query?request=#{requestType}&channel=#{channel}&version=#{version}&x={x}&y={y}&z={z}", {
            minZoom: 1
            maxZoom: 18
          }).addTo(@map)

          if requestType is "ImageryMaps"
            baseMaps[label] = tileLayer
          else
            overlayMaps[label] = tileLayer

      layerControl = L.control.layers(baseMaps, overlayMaps).addTo(@map)

      # Drawing toolbar
      @drawnItems = new L.FeatureGroup()
      @map.addLayer(@drawnItems)
      drawControl = new L.Control.Draw
        draw:
          polyline: false
          polygon: false
          circle: false
          marker: false
        edit:
          featureGroup: @drawnItems
      @map.addControl(drawControl)

      # Register to events
      @_registerToDrawEvents()
      @_registerToMoveEvents()


    _registerToMoveEvents: ->
      @map.on 'moveend', (e) =>
      console.log "on moveend"
      @_populateHeatmapData()

    _registerToDrawEvents: ->
      @map.on 'draw:edited', (e) =>
        console.log "edited"
        if @bboxLayer?
          console.log "editing layer"
          bounds = @bboxLayer.getBounds()
          console.log bounds
          data =
            northEast:
              lat: bounds.getNorth()
              lng: bounds.getEast()
            southWest:
              lat: bounds.getSouth()
              lng: bounds.getWest()

          @_publish 'bboxDrawn', data

      @map.on 'draw:deleted', (e) =>
        console.log "deleted"
        if @bboxLayer?
          console.log "deleted removing layer"
          @drawnItems.removeLayer(@bboxLayer)
          @_publish 'bboxDeleted'
          @bboxLayer = null

      @map.on 'draw:drawstart', (e) =>
        console.log "drawstart"
        if @bboxLayer?
          console.log "drawstart removing layer"
          @drawnItems.removeLayer(@bboxLayer)
          @_publish 'bboxDeleted'
          @bboxLayer = null

      @map.on 'draw:created', (e) =>
        @bboxLayer = e.layer
        bounds = @bboxLayer.getBounds()
        console.log bounds
        data =
          northEast:
            lat: bounds.getNorth()
            lng: bounds.getEast()
          southWest:
            lat: bounds.getSouth()
            lng: bounds.getWest()

        @_publish 'bboxDrawn', data

        @drawnItems.addLayer(@bboxLayer)


    _publish: (name, data) ->
      if @handlers[name]?
        for callback in @handlers[name]
          callback(data)

    _determineDataset: (bounds) ->
      lat_diff = Math.abs(bounds.getNorth() - bounds.getSouth())
      lng_diff = Math.abs(bounds.getEast() - bounds.getWest())

      console.log "lat_diff", lat_diff
      console.log "lng_diff", lng_diff
      precision = _determineGeohashPrecision(lat_diff, lng_diff)
      console.log "precision", precision
      @geoHashDataSets["set_#{precision}"]


    _populateHeatmapData: ->
      return unless @map?

      viewport =  @map.getBounds()
      goodPoints = []
      geoHashData = @_determineDataset(viewport)
      if geoHashData?
        for point in geoHashData
          p = new L.LatLng(point.lat, point.lon)
          if viewport.contains(p)
            goodPoints.push point
        console.log "setting points"
        console.log goodPoints.length
        if goodPoints.length > 0
          @heatmapLayer.setData(goodPoints)