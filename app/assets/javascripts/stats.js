var legendTemplate = " \
	<div class=\"btn-group-vertical\" role=\"group\"> \
		<% for (var i=0; i<datasets.length; i++){%> \
			<button type=\"button\" \
					class=\"btn btn-default dropdown-toggle\" \
					data-toggle=\"dropdown\" \
					aria-expanded=\"false\" disabled=\"true\" style=\"color: <%=datasets[i].strokeColor%>;\"> \
						<%if(datasets[i].label){%> \
							<%=datasets[i].label%> \
						<%}%> \
		<%}%> \
	</div> \
";

var strokeColors = [
	"rgb(0,0,0)",
	"rgb(255,0,0)",
	"rgb(0,255,0)",
	"rgb(0,0,255)",
	"rgb(0,255,255)",
	"rgb(255,0,255)",
];

var fillColor = "rgba(220,220,220,0)";
var pointColor = "rgba(0,0,0,0)";
var pointStrokeColor = "#fff";

$(document).ready(function() {
	var labels = Object.keys(points);

	var data = {
		labels: [""].concat(points[labels[0]].map(function(value, index) { 
			return "Week " + (index + 1);
			})
		),
		datasets: labels.map(function(username, index) {
			return {
				label: username,
				fillColor : fillColor,
	        	strokeColor : strokeColors[index],
	        	pointColor : pointColor,
	        	pointStrokeColor : pointStrokeColor,
	        	data: [0].concat(points[username])
			};
		}),
	};

	var pointsChart = new Chart($("#pointsChart").get(0).getContext("2d")).Line(
		data,
		{
    		showTooltips : false,
      		bezierCurveTension: 0.1,
      		legendTemplate : legendTemplate,
      		responsive : true,
      		pointDot : false
    	}
	);

	$('#pointsChartLegend').html(pointsChart.generateLegend());
});