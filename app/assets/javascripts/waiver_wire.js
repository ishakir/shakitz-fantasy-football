$(document).ready(function() {
  selector();
});

var selector = function(){
  initPlayerSuggestions(
    playerData, 
    function(player) {
      checkPlayerTeamAndUpdate(player.id);
  });
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
  $("#swapButton").click(function(){
  	initSpinner();
    populateIdArrays();
    $.ajax({
      type: "POST",
      url: "/user/declare_roster",
      data: { user_id: userId, game_week: currentGameWeek, playing_player_id: playingId, benched_player_id: benchedId }
    })
    .done(function( msg ) {
      if(msg.status == 200){
        $('#swap-success').show();
      } else {
        $('#swap-error').show();
        $('#swap-error-msg').html(msg.response);
      }
      spinner.stop();
    });
  });
};

var selector = function() {
  initPlayerSuggestions(
    players, 
    function(player) {
      playerToBeAdded = player.id;
  });
};


//code taken from http://www.avtex.com/blog/2015/01/27/drag-and-drop-sorting-of-table-rows-in-priority-order/ 
$(document).ready(function() { //Helper function to keep table row from collapsing when being sorted     
   var fixHelperModified = function(e, tr) {
      var $originals = tr.children();
      var $helper = tr.clone();
      $helper.children().each(function(index) {
         $(this).width($originals.eq(index).width());
      });
      return $helper;
   };
   //Make diagnosis table sortable     
   $("#diagnosis_list tbody").sortable({
      helper: fixHelperModified,
      stop: function(event, ui) {
         renumber_table('#diagnosis_list');
      }
   }).disableSelection();
   //Delete button in table rows     
   $('table').on('click', '.btn-delete', function() {
      tableID = '#' + $(this).closest('table').attr('id');
      r = confirm('Delete this item?');
      if (r) {
         $(this).closest('tr').remove();
         renumber_table(tableID);
      }
   });
});
//Renumber table rows 
function renumber_table(tableID) {
   $(tableID + " tr").each(function() {
      count = $(this).parent().children().index($(this)) + 1;
      $(this).find('.priority').html(count);
   });
}