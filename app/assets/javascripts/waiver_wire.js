var selector = function() {
  initPlayerSuggestions(
    players, 
    function(player) {
      playerToBeAdded = player.id;
  });
};
var incomingId = -1;
var waiverList = [];

//code taken from http://www.avtex.com/blog/2015/01/27/drag-and-drop-sorting-of-table-rows-in-priority-order/ 
$(document).ready(function() { //Helper function to keep table row from collapsing when being sorted   
	$('#incoming-player-text').on("typeahead:selected typeahead:autocompleted", function(e,datum) { 
		incomingId = datum.id; 
	});
	selector();
   var fixHelperModified = function(e, tr) {
      var $originals = tr.children();
      var $helper = tr.clone();
      $helper.children().each(function(index) {
         $(this).width($originals.eq(index).width());
      });
      return $helper;
   };
   $("#waiver-list tbody").sortable({
      helper: fixHelperModified,
      stop: function(event, ui) {
         renumber_table('#waiver-list');
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
   //Add row
   $('#submitWaiver').on('click', function(){
   	console.log(waiverList);
	 $.ajax({
      type: "POST",
      url: "/waiver_wire/request",
      data: JSON.stringify({request: waiverList}),
      dataType: 'json',
      contentType: 'application/json'
    })
    .done(function( msg ) {
      if(msg.status == 200){
        console.log('it worked');
      } else {
	      console.log(msg.response);
      }
      spinner.stop();
    })
    .fail(function(msg){
	  	console.log(waiverList);
		console.log(msg);
    });
   });
   
   $('#addBtn').on('click', function(e){
   	var outgoing = $('#my-player').val();
   	var outgoingId = $('#my-player').find(":selected")[0].id.split('-')[1];
   	var incoming = $('#incoming-player-text').typeahead('val');
   	var priority = $('#waiver-list tr').length;//headers count as one row
   	if(!outgoing || !incoming || !incomingId || !outgoingId){
   		return;
   	}
   	var request = {
		user: user,
   		player_in: incomingId,
   		player_out: parseInt(outgoingId, 10),
   		game_week: gameWeek,
   		incoming_priority: priority, 
   	};
   	waiverList.push(request);
   	var html = '<tr><td class="priority">'+priority+'</td><td id="outgoing-'+outgoingId+'" class="outgoing">'+outgoing+
   		'</td><td id="incoming-'+incomingId+'" class="incoming">'+incoming+'</td><td><a class="btn btn-delete btn-danger">Delete</a></td>';
   	$("#waiver-list").find('tbody').append(html);
   });
}.bind(this));
//Renumber table rows 
function renumber_table(tableID) {
   $(tableID + " tr").each(function(i, tr) {
   	  updateWaiverRequest(tr);
      count = $(this).parent().children().index($(this)) + 1;
      $(this).find('.priority').html(count);
   });
};

function updateWaiverRequest(tr) {
	$(tr).each(function(i, td){
		var outgoing = $(td).find('.outgoing')[0];
		var incoming = $(td).find('.incoming')[0];
		if(outgoing && incoming && outgoing.id && incoming.id){
			outId = outgoing.id.split('-')[1];
			inId = incoming.id.split('-')[1];
			for(var i = 0; i < waiverList.length; i++){
				var waiver = waiverList[i];
				if(waiver.player_in == inId && waiver.player_out == outId){
					waiverList[i].incoming_priority = $($(td).find('.priority')[0]).html();
				}
			}
		}
	});
}
