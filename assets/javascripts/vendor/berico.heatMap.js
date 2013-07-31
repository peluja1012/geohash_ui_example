

define('lib/random',[],function(){return console.log("yeah dep")});
define('lib/geohash_widget',["leaflet","leaflet_draw","leaflet_heatmap","./random"],function(){console.log("YEAAAAHHHHH");var e,t;return t=function(e,t){var a,r;return r=.04394>t?6:.3515>t?5:1.406>t?4:11.25>t?3:45>t?2:1,a=.04394>e?6:.1757>e?5:1.40625>e?4:5.625>e?3:45>e?2:1,Math.min(a,r)},e=function(){function e(){this.map=null,this.handlers={},this.bboxLayer=null,this.geoHashDataSets={set_1:null,set_2:null,set_3:null,set_4:null,set_5:null},this.drawnItems=null}return e.prototype.on=function(e,t){return null==this.handlers[e]&&(this.handlers[e]=[]),this.handlers[e].push(t)},e.prototype.resetData=function(e){var t,a,r,o;for(a=r=0,o=e.length;o>r;a=++r)t=e[a],this.geoHashDataSets["set_"+(a+1)]=t;return this._populateHeatmapData()},e.prototype.bbox=function(e,t,a,r){var o,l,n,s,i,h;return i={stroke:!0,color:"#f06eaa",weight:4,opacity:.5,fill:!0,fillColor:null,fillOpacity:.2,clickable:!0},n=new L.LatLng(e,t),h=new L.LatLng(a,r),o=new L.LatLngBounds(h,n),s=new L.Rectangle(o,i),s.addTo(this.drawnItems),this.bboxLayer=s,l={northEast:{lat:e,lng:t},southWest:{lat:a,lng:r}},this._publish("bboxDrawn",l)},e.prototype.deleteBbox=function(){return null!=this.bboxLayer?(console.log("deleted removing layer"),this.drawnItems.removeLayer(this.bboxLayer),this._publish("bboxDeleted"),this.bboxLayer=null):void 0},e.prototype.draw=function(e){var t,a,r,o,l,n,s,i,h,u,d,p,g,b;if(null==e.el)throw new Error("Please provide a value for the [el] option");if(null==e.mapUrl)throw new Error("Please provide a value for the [mapUrl] option");if(null!=e.imagePath&&(L.Icon.Default.imagePath=""+e.imagePath),this.heatmapLayer=L.TileLayer.heatMap({radius:{value:20,absolute:!1},opacity:.8,gradient:{.45:"rgb(0,0,255)",.55:"rgb(0,255,255)",.65:"rgb(0,255,0)",.95:"yellow",1:"rgb(255,0,0)"}}),this.map=L.map(e.el,{layers:[this.heatmapLayer]}).setView([0,0],1),i={},t={},i.heat=this.heatmapLayer,"undefined"!=typeof geeServerDefs&&null!==geeServerDefs)for(console.log(geeServerDefs),b=geeServerDefs.layers,o=p=0,g=b.length;g>p;o=++p)n=b[o],a=n.id,h=n.requestType,d=n.version,l=n.label,u=L.tileLayer(""+e.mapUrl+"/query?request="+h+"&channel="+a+"&version="+d+"&x={x}&y={y}&z={z}",{minZoom:1,maxZoom:18}).addTo(this.map),"ImageryMaps"===h?t[l]=u:i[l]=u;return s=L.control.layers(t,i).addTo(this.map),this.drawnItems=new L.FeatureGroup,this.map.addLayer(this.drawnItems),r=new L.Control.Draw({draw:{polyline:!1,polygon:!1,circle:!1,marker:!1},edit:{featureGroup:this.drawnItems}}),this.map.addControl(r),this._registerToDrawEvents(),this._registerToMoveEvents()},e.prototype._registerToMoveEvents=function(){return this.map.on("moveend",function(){}),console.log("on moveend"),this._populateHeatmapData()},e.prototype._registerToDrawEvents=function(){var e=this;return this.map.on("draw:edited",function(){var t,a;return console.log("edited"),null!=e.bboxLayer?(console.log("editing layer"),t=e.bboxLayer.getBounds(),console.log(t),a={northEast:{lat:t.getNorth(),lng:t.getEast()},southWest:{lat:t.getSouth(),lng:t.getWest()}},e._publish("bboxDrawn",a)):void 0}),this.map.on("draw:deleted",function(){return console.log("deleted"),null!=e.bboxLayer?(console.log("deleted removing layer"),e.drawnItems.removeLayer(e.bboxLayer),e._publish("bboxDeleted"),e.bboxLayer=null):void 0}),this.map.on("draw:drawstart",function(){return console.log("drawstart"),null!=e.bboxLayer?(console.log("drawstart removing layer"),e.drawnItems.removeLayer(e.bboxLayer),e._publish("bboxDeleted"),e.bboxLayer=null):void 0}),this.map.on("draw:created",function(t){var a,r;return e.bboxLayer=t.layer,a=e.bboxLayer.getBounds(),console.log(a),r={northEast:{lat:a.getNorth(),lng:a.getEast()},southWest:{lat:a.getSouth(),lng:a.getWest()}},e._publish("bboxDrawn",r),e.drawnItems.addLayer(e.bboxLayer)})},e.prototype._publish=function(e,t){var a,r,o,l,n;if(null!=this.handlers[e]){for(l=this.handlers[e],n=[],r=0,o=l.length;o>r;r++)a=l[r],n.push(a(t));return n}},e.prototype._determineDataset=function(e){var a,r,o;return a=Math.abs(e.getNorth()-e.getSouth()),r=Math.abs(e.getEast()-e.getWest()),console.log("lat_diff",a),console.log("lng_diff",r),o=t(a,r),console.log("precision",o),this.geoHashDataSets["set_"+o]},e.prototype._populateHeatmapData=function(){var e,t,a,r,o,l,n;if(null!=this.map&&(o=this.map.getBounds(),t=[],e=this._determineDataset(o),null!=e)){for(l=0,n=e.length;n>l;l++)r=e[l],a=new L.LatLng(r.lat,r.lon),o.contains(a)&&t.push(r);if(console.log("setting points"),console.log(t.length),t.length>0)return this.heatmapLayer.setData(t)}},e}()});

define(['lib/geohash_widget'], function(lib) {
  return lib;
});