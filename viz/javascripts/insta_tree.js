

var margin = {top: 40, right: 10, bottom: 10, left: 10},
    width = 1000 - margin.left - margin.right,
    height = 600 - margin.top - margin.bottom;

var color = d3.scale.category20c();

var treemap = d3.layout.treemap()
    .size([width, height])
    .sticky(true)
    .value(function(d) { return d.size; });

var div = d3.select("body").append("div")
    .style("position", "relative")
    .style("width", (width + margin.left + margin.right) + "px")
    .style("height", (height + margin.top + margin.bottom) + "px")
    .style("left", margin.left + "px")
    .style("top", margin.top + "px");

// Set background-image based on data
var getBackgroundStyle = function(d) {
    return 'url(' + d.url + ') ';
};

d3.json("data/insta_flare.json", function(error, root) {
  var node = div.datum(root).selectAll(".node")
      .data(treemap.nodes)
    .enter().append("div")
      .attr("class", "node")
       .call(position)
      .style("background", getBackgroundStyle)
      .style("background-size", "cover")
      .style("background-repeat", "no-repeat")
      .style("background-position", "center")
      .style("background-color", function(d) { return d.children ? color(d.name) : null; })
       .call(d3.helper.tooltip()
                .attr({class: function(d, i) { return d + ' ' +  i + ' A'; }})
                .style({color: 'blue'})
                .text(function(d, i){ return 'title:' + d.name + '; search count: '+d.size ; })
            )
      .on('click', function(d) {window.location.href = d.href;})
      //.text(function(d) { return d.children ? null : d.name; });


  d3.selectAll("input").on("change", function change() {
    var value = this.value === "count"
        ? function() { return 1; }
        : function(d) { return d.size; };

    node
        .data(treemap.value(value).nodes)
      .transition()
        .duration(1500)
        .call(position);
  });
});

function position() {
  this.style("left", function(d) { return d.x + "px"; })
      .style("top", function(d) { return d.y + "px"; })
      .style("width", function(d) { return Math.max(0, d.dx - 1) + "px"; })
      .style("height", function(d) { return Math.max(0, d.dy - 1) + "px"; });
}

