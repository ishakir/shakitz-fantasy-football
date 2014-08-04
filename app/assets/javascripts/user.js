var currentlyClicked = null;
var playingId = [];
var benchedId = [];
var spinner;
var select;
var playerToBeAdded;

var setTableHandlers = function(){
  var context = this;
  $(".benched tr").click(function() {
    $node = $(this);
    swapElements($node[0].innerHTML, $node[0].id);
  });
  $(".active-roster tr").click(function() {
    $node = $(this);
    swapElements($node[0].innerHTML, $node[0].id);
  });
};

var swapElements = function(node, id){
  $firstNode = $("#"+currentlyClicked);
  if(currentlyClicked == null || currentlyClicked == id){
    currentlyClicked = id;
    $("#"+currentlyClicked).addClass("first-select", 300);
  } else{
    $new = $("#"+id);
    $("#"+id).addClass("second-select", 300);
    swapNodes($firstNode[0], $new[0]);
    $("#"+id).removeClass("second-select", 400);
    $("#"+currentlyClicked).removeClass("first-select", 400);
    currentlyClicked = null;
  }  
};

var validatePositionCount = function(oldNode, newNode){
  var qbCnt = 0, wrCnt = 0, rbCnt = 0, teCnt = 0, kCnt = 0, dCnt = 0;  
  $(".active-roster .player-pos").each(function(i, value){
    switch(value.innerHTML.trim()){
      case "QB": 
        qbCnt++;
        break;
      case "WR": 
        wrCnt++;
        break;
      case "RB":
        rbCnt++;
        break;
      case "TE":
        teCnt++;
        break;
      case "K":
        kCnt++;
        break;
      case "D":
        dCnt++;
        break;
      default:
         break;
    }
  });
  if(qbCnt == 2 && rbCnt == 2 && dCnt ==1 && (validRestOfTeam(tCnt, kCnt, wrCnt))){
    var oldPos, newPos;
    $(oldNode).find(".player-pos").each(function(i, value){
      oldPos = value.innerHTML.trim();
    });
    $(newNode).find(".player-pos").each(function(i, value){
      newPos = value.innerHTML.trim();  
    });
    if(oldPos == newPos){
      return true;
    }
  }
  return false;
};

var validRestOfTeam = function(tCnt, kCnt, wrCnt){
  if(tCnt + kCnt + wrCnt > 4){
    return false;
  } else if(wrCnt > 3){
    return false;
  } else if(kCnt > 2){
    return false;
  } else if(tCnt > 2){
    return false;
  }
  return true;
};

//Taken from Bobince's answer at: https://stackoverflow.com/questions/698301/is-there-a-native-jquery-function-to-switch-elements
var swapNodes = function(a, b){
  if(a.parentNode == b.parentNode || this.validatePositionCount(a, b)){
    var aparent= a.parentNode;
    var asibling= a.nextSibling===b? a : a.nextSibling;
    b.parentNode.insertBefore(a, b);
    aparent.insertBefore(b, asibling);
  } else{
    $('#swap-error').show();
    $('#swap-error-msg').html("Unable to swap players, ineligble team fielded");
  }
};

var populateIdArrays = function(){
  var context = this;
  context.benchedId = [];
  context.playingId = [];
  $('.active-roster tr').each(function(i, value){
    var sId = parseInt(value.id.replace('Row', ''));
    if(!isNaN(sId)){
      context.playingId.push(parseInt(sId));
    }
  });
  $('.benched tr').each(function(i, value){
    var sId = parseInt(value.id.replace('Row', ''));
    if(!isNaN(sId)){
      context.benchedId.push(parseInt(sId));
    }
  });
};

var setAlertHandler = function(){
  $('.alert .close').on('click', function(e) {
      $(this).parent().hide();
  });    
};

var initSpinner = function(){
  if(spinner == null){
    var opts = {
      lines: 13, // The number of lines to draw
      length: 20, // The length of each line
      width: 14, // The line thickness
      radius: 44, // The radius of the inner circle
      corners: 1, // Corner roundness (0..1)
      rotate: 0, // The rotation offset
      direction: 1, // 1: clockwise, -1: counterclockwise
      color: '#000', // #rgb or #rrggbb or array of colors
      speed: 1, // Rounds per second
      trail: 40, // Afterglow percentage
      shadow: true, // Whether to render a shadow
      hwaccel: false, // Whether to use hardware acceleration
      className: 'spinner', // The CSS class to assign to the spinner
      zIndex: 2e9, // The z-index (defaults to 2000000000)
      top: '30%', // Top position relative to parent
      left: '50%' // Left position relative to parent
    };
    var target = document.getElementById('rosters');
    spinner = new Spinner(opts).spin(target);
  } else {
    spinner.spin();
  }
};

var setGameWeekToggleButtonHandlers = function(){
  $("#prevWeekBtn").on("click", function(){
    loadTeamGameWeek(currentGameWeek, false);
  });
  $("#nextWeekBtn").on("click", function(){
    loadTeamGameWeek(currentGameWeek, true);
  });
};

var loadTeamGameWeek = function(gameweek, inFuture){
  var url = "/user/" + this.userId + "/game_week/";
  if(inFuture){
    gameweek += 1;
    if(gameweek <= this.activeGameWeek){
      location.href=url+gameweek;
    }
  } else {
    gameweek -= 1;
    if(gameweek > 0){
      location.href=url+gameweek;
    }
  }
};

var setAddPlayerButtonHandler = function(){
	if($("#bloodhound").length){
		$("#addPlayerButton").click(function(){
			var url = window.location;
			if(playerToBeAdded != undefined && playerToBeAdded > 0){
				initSpinner();
				$.ajax({
			      type: "POST",
			      url: "/team_player/add_player",
			      data: { user_id: userId, player_id: playerToBeAdded }
			    })
			    .done(function( msg ) {
			    	location.href = url;
			      if(msg.status != 200){
			        $('#swap-error').show();
			        $('#swap-error-msg').html(msg.response);
			      }
			      spinner.stop();
			    });
			}
		});
	}
};

var setSaveButtonHandler = function(){
  initSpinner();
  $("#swapButton").click(function(){
    populateIdArrays();
    $.ajax({
      type: "POST",
      url: "/user/declare_roster",
      data: { user_id: this.userId, game_week: 1, playing_player_id: this.playingId, benched_player_id: this.benchedId }
    })
    .done(function( msg ) {
      if(msg.status == 200){
        $('#swap-success').show();
      } else {
        $('#swap-error').show();
        $('#swap-error-msg').html(msg.response);
      }
      context.spinner.stop();
    });
  });
};

var selector = function(){
	// constructs the suggestion engine
	var playerList = new Bloodhound({
	  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
	  queryTokenizer: Bloodhound.tokenizers.whitespace,
	  teamTokenizer: Bloodhound.tokenizers.obj.whitespace('team'),
	  local: $.map(players, function(p) { return { value: p.player.name, id: p.player.id, team: p.team }; })
	});
	// kicks off the loading/processing of `local` and `prefetch`
	playerList.initialize();

	$('#bloodhound .typeahead').typeahead({
		hint: true,
	  	highlight: true,
	 	minLength: 1
	}, {
		name: 'nfl_players',
	  	displayKey: 'value',
	  	source: playerList.ttAdapter(),
	  	templates: {
	  		suggestion: function (datum) {
		           return datum.value + " <span class=\"text-muted small\"> in " + datum.team + "</span>";
		    }
	  	}
	}).bind('typeahead:selected', function($e, player){
		playerToBeAdded = player.id;
    });
};

$(function(){
  if(this.isUser && (this.currentGameWeek == this.activeGameWeek)){
    setTableHandlers();
    setAlertHandler();
    setSaveButtonHandler();
  }
  setAddPlayerButtonHandler();
  setGameWeekToggleButtonHandlers();
  selector();
});


