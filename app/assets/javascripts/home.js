
var min_num_game_week = 1;

var entityMap = {
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': '&quot;',
    "'": '&#39;',
    "/": '&#x2F;'
  };

var escapeHtml = function (string) {
    return String(string).replace(/[&<>"'\/]/g, function (s) {
      return entityMap[s];
    });
  };
  
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
	  		html+= "<tr><td align=\"center\"><strong>"+escapeHtml(d.home_name)+"</strong>";
	  		html+= "  <em>vs</em>  ";
	  		html+= "<strong>"+escapeHtml(d.away_name)+"</strong></td></tr>"; 
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
	$("#register-link").on("click", function(e){
		e.preventDefault();
	});
});