AF.Project = Backbone.Model.extend
  url: ->
    '/projects/'+@id
  lastVelocities: ->
    _(@get('velocities')).chain().pluck('velocity').compact().value()