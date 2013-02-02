Handlebars.registerHelper 'fragileCssClasses', () ->
  classes = ["fragile"]
  classes.push if this.runnable then "runnable" else "non-runnable"
  classes.push if this.active then "active" else "inactive"
  classes.join(" ")

Handlebars.registerHelper 'consoleLog', () ->
  console.log this

Handlebars.registerHelper 'makeChart', () ->
  console.log(this)
  new Handlebars.SafeString(
    if this.bar_graph
      '<div class="bar-graph" data-graph-x-axis="' + this.bar_graph.x_axis +
      '" data-graph-y-axis="' + this.bar_graph.y_axis +
      '" data-graph-data=\'' + JSON.stringify(this.bar_graph.data) + '\'><svg></svg></div>'
  )

