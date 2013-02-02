AF.Project = Backbone.Model.extend
  url: ->
    '/projects/'+@id
  lastVelocities: ->
    _(@get('velocities')).chain().pluck('velocity').compact().value()

  toJSON: ->
    json = Backbone.Model.prototype.toJSON.apply this, arguments
    fragileGroups = _(json.fragiles).groupBy (frag) =>
      if !frag.runnable
        "nonrunnable"
      else if !frag.active
        "inactive"
      else
        "active"
    json.fragiles = fragileGroups
    json
