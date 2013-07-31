jsonData = require('./sample_geohash_data')

##
# Web Console Test:
# $.ajax({url:"/geohashdata", success:function(data){console.log(data);}});
##
exports.getData = (req, res) ->
  res.send 200, jsonData


