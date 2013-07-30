window.MIMOSA_TEST_REQUIRE_CONFIG = {
  "shim": {
    "leaflet_draw": {
      "deps": [
        "leaflet"
      ]
    },
    "leaflet_markercluster": {
      "deps": [
        "leaflet"
      ]
    },
    "leaflet_heatmap": {
      "deps": [
        "leaflet"
      ]
    }
  },
  "paths": {
    "jquery": "vendor/jquery",
    "underscore": "vendor/lodash.min",
    "backbone": "common/util/backbone-extended",
    "leaflet": "vendor/leaflet-src",
    "leaflet_draw": "vendor/leaflet.draw-src",
    "leaflet_markercluster": "vendor/leaflet.markercluster-src",
    "leaflet_heatmap": "vendor/heatmap-leaflet"
  },
  "baseUrl": "/js"
};
window.MIMOSA_TEST_MOCHA_SETUP = {
  "ui": "bdd"
};
window.MIMOSA_TEST_SPECS = [
  "spec/geohash_widget_spec"
];