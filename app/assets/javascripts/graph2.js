jQuery(document).ready(function($) {

  var width  = getUrlParameter('width')  || $(window).width() || 600;
      height = getUrlParameter('height') || 300;

  var margin = {top: 20, right: 80, bottom: 30, left: 50}

  width = width - margin.left - margin.right,
  height = height - margin.top - margin.bottom;

  $('img.spectrum').width(width)
                   .height(100)
                   .css('margin-left',margin.left);

  var svg = d3.select("#graph").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)

  nv.addGraph(function() {
    var chart = nv.models.lineChart()
                  .height(height)  //Adjust chart margins to give the x-axis some breathing room.
                  .margin(margin)  //Adjust chart margins to give the x-axis some breathing room.
                  .useInteractiveGuideline(true)  //We want nice looking tooltips and a guideline!
//                  .transitionDuration(350)  //how fast do you want the lines to transition?
                  .showLegend(false)       //Show the legend, allowing users to turn on/off line series.
                  .showYAxis(true)        //Show the y-axis
                  .showXAxis(true)        //Show the x-axis
    ;
 
    chart.xAxis     //Chart x-axis settings
        .axisLabel('Wavelength (nanometer)')
        .tickFormat(d3.format('1d'));
 
    chart.yAxis     //Chart y-axis settings
        .axisLabel('Intensity (%)')
        .tickFormat(d3.format('%'));
 
    d3.json("/spectrums/"+spectrum_id+".json", function(error, data) {
      console.log('json loaded');

      var average = []
          red     = [];
          green   = [];
          blue    = [];

      // Present x and y properties like data.x and data.y
      $.each(data.data.lines,function(i,data) {
        if (data.wavelength == null) {
          var x = data.pixel
          // change graph labels
        } else var x = data.wavelength

        average.push({y:data.average/255,x:x})
        red.push(    {y:data.r/255,      x:x})
        green.push(  {y:data.g/255,      x:x})
        blue.push(   {y:data.b/255,      x:x})
      });

      d3.select('#graph svg')    //Select the <svg> element you want to render the chart in.   
          .datum([{ 
              values: average,
              key: data.title+" (average)",
              color: '#444'
            },
            {
              values: red,
              key: data.title+" (R)",
              color: 'rgba(255,0,0,0.2)'
            },
            {
              values: green,
              key: data.title+" (G)",
              color: 'rgba(0,255,0,0.2)'
            },
            {
              values: blue,
              key: data.title+" (B)",
              color: 'rgba(0,0,255,0.2)'
            }
          ])         //Populate the <svg> element with chart data...
          .call(chart);          //Finally, render the chart!
    })
 
    //Update the chart when window resizes.
    nv.utils.windowResize(function() { chart.update() });
    return chart;
  });

/*
  var x = d3.scale.linear()
    .range([0, width]);

  var y = d3.scale.linear()
    .range([height, 0]);

  var color = d3.scale.category10();

  var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");

  var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left");

  var line = d3.svg.line()
    .interpolate("basis")
    .x(function(d) { return x(d.wavelength); })
    .y(function(d) { return y(d.intensity); });

  var svg = d3.select("#graph").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  d3.json("/spectrums/"+spectrum_id+".json", function(error, data) {
    console.log('json loaded');

    svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
    .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("Intensity (%)");
  }) 

  var spectra = color.domain().map(function(name) {
    return {
      name: name,
      values: data.data.lines.map(function(d) {
        return {intensity: d.average, wavelength: +d.wavelength};
      })
    };
  });

  var spectrum = svg.selectAll(".spectrum")
    .data(spectra)
  .enter().append("g")
    .attr("class", "spectrum");

  svg.append("path")
    .attr("class", "line")
    .attr("d", function(d) { return line(d.values); })
    //.style("stroke", function(d) { return color(d.name); });

*/

});
