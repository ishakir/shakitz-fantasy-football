
var setActionHandlers = function(){
	setIncomingHandlers();
	setOutgoingHandlers();
};

var setIncomingHandlers = function(){
	$('#my-action').find('.out button').click(function(e){
		var id = e.target.parentNode.parentNode.id.split('_')[1];
		$('#transfer_request_id').val(id);
		if(e.target.innerHTML === "Reject"){
			$('#action_type').val("reject");
			$('#transferModalText').html("Are you sure you want to reject this transfer?");
		} else if(e.target.innerHTML === "Accept"){
			$('#action_type').val("accept");
			$('#transferModalText').html("Are you sure you want to accept this transfer?");
		}
		$('#actionModal').modal('show');
	});
};

var setOutgoingHandlers = function(){
	$('#my-action').find('.inc button').click(function(e){
		var id = e.target.parentNode.id.split('_')[1];
		$('#transfer_request_id').val(id);
		$('#action_type').val("cancel");
		$('#actionModal').modal('show');
		$('#transferModalText').html("Are you sure you want to cancel this transfer?");
	});
};

$(function(){
	setActionHandlers();
});