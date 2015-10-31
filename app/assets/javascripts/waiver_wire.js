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
$(function() { //Helper function to keep table row from collapsing when being sorted
  checkForNewSmack();
  selector();
	if(existingRequests){
		convertExistingWaivers();
	}
	updateTable(existingRequests);
	checkWhetherToLockWaiver();
	assignListeners();
}.bind(this));

function checkWhetherToLockWaiver() {
	if(gameWeekTimeObj.locked){
		$("#submitWaiver").prop("disabled", true);
		$("#submitWaiver").html("Waivers locked until next gamweek");
	}
}

function convertExistingWaivers() {
	for(var i = 0; i < existingRequests.length; i++){
		var request = existingRequests[i];
		waiverList.push({
			user: user,
	   		player_in: request.incomingId,
	   		player_out: request.outgoingId,
	   		game_week: gameWeek,
	   		incoming_priority: request.priority
   		});
	}
}

function assignListeners() {
	$('#incoming-player-text').on("typeahead:selected typeahead:autocompleted", function(e,datum) {
		incomingId = datum.id;
	});
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
      	 var row = $(this).closest('tr');
      	 removeWaiver(row);
         row.remove();
         renumber_table(tableID);
      }
   });
   //Add row
   $('#submitWaiver').on('click', function(){
	 $.ajax({
      type: "POST",
      url: "/waiver_wire/request",
      data: JSON.stringify({request: waiverList}),
      dataType: 'json',
      contentType: 'application/json'
    })
    .done(function(msg){
      var successMessage = 'Waiver wire successfully submitted. You will be able to modify it until Wednesday 10pm (UK)';
	  $('#waiverModal').modal('show');
	  $('#waiverMessage').text(successMessage);
    })
    .fail(function(msg){
	  	if(msg.status != 200){
  		  $('#waiverModal').modal('show');
		  $('#waiverMessage').text('Error submitting waiver request: ' + msg);
	  	}
    });
   });

   $('#addBtn').on('click', function(e){
   	var obj = {
   		outgoing: $('#my-player').val(),
   		outgoingId: $('#my-player').find(":selected")[0].id.split('-')[1],
   		incoming: $('#incoming-player-text').typeahead('val'),
	 	incomingId: incomingId,
   		priority: $('#waiver-list tr').length//headers count as one row
   	};
   	if(!obj.outgoing || !obj.incoming || !obj.incomingId || !obj.outgoingId){
   		return;
   	}
   	var request = {
		user: user,
   		player_in: obj.incomingId,
   		player_out: parseInt(obj.outgoingId, 10),
   		game_week: gameWeek,
   		incoming_priority: obj.priority,
   	};
   	waiverList.push(request);
   	updateTable([obj]);
   });
};

function fixHelperModified(e, tr) {
  var $originals = tr.children();
  var $helper = tr.clone();
  $helper.children().each(function(index) {
     $(this).width($originals.eq(index).width());
  });
  return $helper;
};
function renumber_table(tableID) {
   $(tableID + " tr").each(function(i, tr) {
      count = $(this).parent().children().index($(this)) + 1;
      $(this).find('.priority').html(count);
 	  updateWaiverRequest(tr);
   });
};

function updateTable(obj) {
	var html = '';
	for(var i = 0; i < obj.length; i++) {
	   	html += '<tr><td class="priority">'+obj[i].priority+'</td><td id="outgoing-'+obj[i].outgoingId+
	   		'" class="outgoing">'+obj[i].outgoing+'</td><td id="incoming-'+obj[i].incomingId+'" class="incoming">'+
	   		obj[i].incoming+'</td><td><a class="btn btn-delete btn-danger">Delete</a></td></tr>';
	}
   	$("#waiver-list").find('tbody').append(html);
}

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
					waiverList[i].incoming_priority = parseInt($($(td).find('.priority')[0]).html(), 10);
				}
			}
		}
	});
}

function removeWaiver(row) {
	var priority = parseInt($($(row).find('.priority')[0]).html(), 10);
	var outgoingId = parseInt($(row).find('.outgoing')[0].id.split('-')[1], 10);
	var incomingId = parseInt($(row).find('.incoming')[0].id.split('-')[1], 10);
	for(var i = waiverList.length-1; i >= 0; i--){
		if(incomingId === waiverList[i].player_in && outgoingId === waiverList[i].player_out &&
			priority === waiverList[i].incoming_priority){
				waiverList.splice(i, 1);
		}
	}
}
