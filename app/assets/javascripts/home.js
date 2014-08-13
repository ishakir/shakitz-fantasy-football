
var min_num_game_week = 1;

var ajaxGameWeek = function(id){
	$.ajax({
	  type: "GET",
	  url: "/fixtures/week/"+id,
	})
	  .done(function(data) {
	  	var html = "";
	  	if(data.length == 0){
			html+= "<tr><td>No fixtures scheduled</td></tr>";
	  	}
	  	
	  	$.each(data, function(key, d){
	  		html+= "<tr><td align=\"center\"><strong>"+d.home_name+"</strong>";
	  		html+= "  <em>vs</em>  ";
	  		html+= "<strong>"+d.away_name+"</strong></td></tr>"; 
	  	});
	  	$("#fixtureTable").html(html);
	  });
 };
 
$(function(){
	ajaxGameWeek(gameweek);
	$("#prevWeek").on("click", function(){
		var id = parseInt($("#gwNumber").html());
		if(id == min_num_game_week){
			return;
		} 
		var newWeek = id-1;
		ajaxGameWeek(newWeek);
		$("#gwNumber").html(newWeek);
	});
	$("#nextWeek").on("click", function(){
		var id = parseInt($("#gwNumber").html());
		if(id == max_num_game_week){
			return;
		}
		var newWeek = id+1;
		ajaxGameWeek(newWeek);
		$("#gwNumber").html(newWeek);
	});
});