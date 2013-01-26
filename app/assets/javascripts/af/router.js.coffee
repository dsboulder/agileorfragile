AF.Router = Backbone.Router.extend
  routes:
    "projects/:id": "project"

  project: (id) ->
    @project = new AF.Project id: id
    @project.fetch()
    @view = new AF.Views.ProjectShow
      app: @app
      el: $('#root')[0]
      project: @project
