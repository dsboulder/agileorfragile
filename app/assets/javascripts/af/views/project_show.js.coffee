AF.Views.ProjectShow = Backbone.View.extend(
  initialize: (options) ->
    @project = options.project
    @listenTo(@project, 'change', @render)
    @delegateEvents
      "click h4 > a": (e) ->
        e.preventDefault()
        $(e.target).closest("h4").next().slideToggle()
      "click a.name": (e) ->
        e.preventDefault()
        $(e.target).closest('.item').toggleClass('expanded').find('.details').slideToggle
          complete: => $(window).trigger('resize')
  render: ->
    json = @project.toJSON()
    html = HandlebarsTemplates.fragiles json
    @$('section.fragile > .content').html html

    @$('.bar-graph').each ->
      $graph = $(this)
      svg = $graph.find 'svg'
      nv.addGraph =>
        chart = nv.models.discreteBarChart()
          .width($graph.closest('item').width())
          .height(svg.height())
          .tooltips(false)
          .showValues(true)
          .valueFormat(d3.format(',.0f'))
          .color (d,i) =>
            if d.class == 'bad' then '#aa0000' else '#1f77b4'
          .margin
            left: 30

        chart.yAxis.showMaxMin(false).tickFormat (y) =>
          Math.round(y)
        chart.xAxis.showMaxMin(false).tickFormat (x) =>
          if x.length then x else Math.round(x)
        chart.xAxis.axisLabel $graph.data('graphXAxis') if $graph.data('graphXAxis')
        chart.yAxis.axisLabel $graph.data('graphYAxis') if $graph.data('graphYAxis')
        data =
          key: ''
          values: $graph.data('graphData')

        d3.select(svg[0])
          .datum([data])
          .call(chart)

        nv.utils.windowResize(chart.update);

        return chart
)
