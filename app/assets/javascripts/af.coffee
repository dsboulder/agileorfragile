window.AF ||= {};
window.AF.Views ||= {};

$ ->
  window.router = new AF.Router()
  Backbone.history.start
    pushState: true

