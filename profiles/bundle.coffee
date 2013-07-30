exports.config =
  modules: ['lint', 'require', 'minify']
  watch:
    exclude:[/\/demo\//]
    compiledDir:"dist"
  require:
    optimize:
      overrides: (runConfig) ->
        runConfig

