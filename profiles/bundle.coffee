exports.config =
  modules: ['lint', 'require', 'minify']
  require:
    optimize:
      overrides: (runConfig) ->
        runConfig

