define ['jquery', 'berico/geohash_widget'], ($, GeohashWidget) ->

  widget = null
  Util = null

  beforeEach ->
    $('body').append("<div id='map'></div>")
    widget = new GeohashWidget.Widget()
    Util = GeohashWidget.Util

  afterEach ->
    $('#map').remove()

  describe 'Geohash Widget', ->

    it 'should enforce that required opts are provided when drawing', ->
      expect(-> widget.draw()).to.throw(Error)
      expect(-> widget.draw({})).to.throw(Error)
      expect(-> widget.draw({el:'map'})).to.throw(Error)
      expect(-> widget.draw({mapUrl:'hello'})).to.throw(Error)

    it 'should allow optional opts to be missing when drawing', ->
      expect(() -> widget.draw({el:'map', mapUrl:'hello'})).to.not.throw(Error)

    describe 'determining which geohash precision to use', ->
      it 'should work correctly when passed a large viewport', ->
        precision = Util.determineGeohashPrecision(60, 60)
        expect(precision).to.equal(1)
        precision = Util.determineGeohashPrecision(30, 60)
        expect(precision).to.equal(1)
        precision = Util.determineGeohashPrecision(60, 30)
        expect(precision).to.equal(1)

      it 'should work correctly when passed a smaller viewport', ->
        precision = Util.determineGeohashPrecision(40, 40)
        expect(precision).to.equal(2)
        precision = Util.determineGeohashPrecision(40, 4)
        expect(precision).to.equal(2)
        precision = Util.determineGeohashPrecision(4, 40)
        expect(precision).to.equal(2)

      it 'should work correctly when passed a very small viewport', ->
        precision = Util.determineGeohashPrecision(4, 4)
        expect(precision).to.equal(3)
        precision = Util.determineGeohashPrecision(4, 1)
        expect(precision).to.equal(3)
        precision = Util.determineGeohashPrecision(1, 4)
        expect(precision).to.equal(3)



