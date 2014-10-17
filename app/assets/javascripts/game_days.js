var ENTER_KEY_CODE = 13;

$(document).ready(function() {
  selector();
  $("#teamText").hide();
  $("#playingOrBenched").hide();
});

var selector = function(){
  initPlayerSuggestions(
    playerData, 
    function(player) {
      checkPlayerTeamAndUpdate(player.id);
  });
};

var checkPlayerTeamAndUpdate = function(playerId) {
  var request_url = "/game_day/" + pageGameWeek + "/which_team"
  $.getJSON(
    request_url,
    { player_id: playerId }
  ).done(function(response) {
    var teamText = $("#teamText");
    var playingOrBenched = $("#playingOrBenched");
    teamText.show();
    playingOrBenched.removeClass("text-danger text-success");
    if(response.data == null) {
      playingOrBenched.hide();
      teamText.text("Player is a free agent");
    } else {
      teamText.text(response.data.name + " - " + response.data.team_name);
      if(response.data.playing) {
        playingOrBenched.html("<strong>Playing</strong>");
        playingOrBenched.addClass("text-success");
      } else {
        playingOrBenched.html("<strong>Benched</strong>");
        playingOrBenched.addClass("text-danger");
      }
      playingOrBenched.show();
    }
  });
}