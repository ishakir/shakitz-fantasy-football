// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var currentChart;

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

$(function(){
	reset_chart("Overall");
	$(".dropdown-menu li a").click(function(){
		reset_chart($(this).text());
	});
});

var reset_chart = function(username, data) {
	if(currentChart) {
		currentChart.destroy();
	}

	var header = $("#chartHeader")
	var points_distribution;
	var ctx = $("#distributionChart").get(0).getContext("2d");
	var data = [];
	var i = 0;

	if(username == "Overall") {
		header.text("Overall Points Spread");
		points_distribution = overall_points_distribution;
	} else {
		header.text("Points Spread for " + username);
		points_distribution = user_specific_points_distribution[username];
	}
	
	for(var player_type in points_distribution) {
		data.push({
			value: points_distribution[player_type],
			color: strokeColors[i],
			label: player_type
		});
		i++;
	}

	currentChart = new Chart(ctx).Doughnut(data, {
	    animateScale: true,
	    responsive: true
	});
};