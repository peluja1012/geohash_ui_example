define ['jquery', 'lib/geohash_widget'], ($, GeohashWidget) ->
  
  widget = null

  before ->
    #$('body').append("<div id='mySearchesContainer'></div>");
    widget = new GeohashWidget()

  describe 'Geohash Widget', ->

    it 'should be awesome', ->
      expect(widget.map).to.equal(null)
