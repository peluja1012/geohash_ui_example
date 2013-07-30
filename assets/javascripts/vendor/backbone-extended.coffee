define ['vendor/backbone.min', 'templates'], (Backbone, TPL) ->

  throwError = (methodName) ->
    throw "#{methodName} should have been overridden for #{getClassName()}"

  getClassName = ->
    if ((typeof @ isnt "object") || (@ is null))
      false
    else
      new RegExp(/(\w+)\(/).exec(@constructor.toString())[1]

  renderTemplate = (name, json = @model.toJSON()) ->
    TPL.render name, json, (error, output) => @$el.html(output)
    @

  appendViews = (emptyFirst, views...) ->
    @$el.empty() if emptyFirst
    @$el.append(view.render().el) for view in views
    @

  findElAndAppendViews = (emptyFirst, selector, views...) ->
    @$(selector).empty() if emptyFirst
    @$(selector).append(view.render().el) for view in views
    @

  # extending the backbone view
  Backbone.View::throwError = throwError
  Backbone.View::getClassName = getClassName
  Backbone.View::renderTemplate = renderTemplate
  Backbone.View::appendViews = appendViews
  Backbone.View::findElAndAppendViews = findElAndAppendViews

  # extending the backbone model
  Backbone.Model::getClassName = getClassName
  Backbone.Model::throwError = throwError
  Backbone
