exports.config =
  modules: ['lint', 'server', 'require', 'minify', 'live-reload', 'combine', 'server-reload']
  combine:
    folders:[{
      folder:"stylesheets/vendor"
      output:"stylesheets/vendor.css"
    }]
  server:
    port:3005