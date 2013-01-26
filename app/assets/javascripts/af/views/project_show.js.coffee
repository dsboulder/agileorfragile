AF.Views.ProjectShow = Backbone.View.extend(
  initialize: (options) ->
    @project = options.project
    @project.on 'change', => @render()
#    @listenTo(@project, 'change', @render)

  render: ->
    console.log("render")
    svg = $('.velocity_chart svg')
    nv.addGraph =>
      chart = nv.models.discreteBarChart()
        .x (d, i) =>
          d.label
        .y (d) =>
          d.value
        .width(svg.width())
        .height(svg.height())
        .tooltips(false)
        .color(nv.utils.getColor(['#1f77b4']))

      chart.xAxis.tickFormat (x) =>
        Math.round(x)
      chart.yAxis.tickFormat (y) =>
        Math.round(y)
      acceptedData =
        key: 'Accepted'
        values: _(@project.get('velocities'))
          .select (v) =>
            v.velocity
          .map (v) =>
            label: v.iteration.number
            value: v.accepted
      velocityData =
        key: 'Velocity'
        values: _(@project.get('velocities'))
          .select (v) =>
            v.velocity
          .map (v) =>
            label: v.iteration.number
            value: v.velocity
      console.log "Data", velocityData
      d3.select('.velocity_chart svg')
        .datum([acceptedData])
        .transition().duration(500)
        .call(chart)

      nv.utils.windowResize(chart.update);

      return chart
#  nv.addGraph(function() {
#  chart = nv.models.lineChart();
#
#    chart
#      .x(function(d,i) { return i })
#
#
#chart.xAxis // chart sub-models (ie. xAxis, yAxis, etc) when accessed directly, return themselves, not the partent chart, so need to chain separately
#  .tickFormat(d3.format(',.1f'));
#
#chart.yAxis
#  .axisLabel('Voltage (v)')
#  .tickFormat(d3.format(',.2f'));
#
#d3.select('#chart1 svg')
#//.datum([]) //for testing noData
#.datum(sinAndCos())
#.transition().duration(500)
#.call(chart);
#
#//TODO: Figure out a good way to do this automatically
#nv.utils.windowResize(chart.update);
#//nv.utils.windowResize(function() { d3.select('#chart1 svg').call(chart) });
#
#chart.dispatch.on('stateChange', function(e) { nv.log('New State:', JSON.stringify(e)); });
#
#return chart;
#});
)