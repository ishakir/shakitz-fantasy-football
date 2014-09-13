
var setActionHandlers = function(){
	setIncomingHandlers();
	setOutgoingHandlers();
};

var setIncomingHandlers = function(){
	$('#my-action').find('.out button').click(function(e){
		var id = e.target.parentNode.parentNode.id.split('_')[1];
		$('#transfer_request_id').val(id);
		if(e.target.innerHTML === "Reject"){
			$('#action_type_id').val("reject");
			$('#transferModalText').html("Are you sure you want to reject this transfer?");
		} else if(e.target.innerHTML === "Accept"){
			$('#action_type_id').val("accept");
			$('#transferModalText').html("Are you sure you want to accept this transfer?");
		}
		$('#actionModal').show();
	});
};

var setOutgoingHandlers = function(){
	$('#my-action').find('.inc button').click(function(e){
		var id = e.target.parentNode.id.split('_')[1];
		$('#transfer_request_id').val(id);
		$('#action_type_id').val("cancel");
		$('#actionModal').show();
		$('#transferModalText').html("Are you sure you want to cancel this transfer?");
	});
};

$(function(){
	setActionHandlers();
});