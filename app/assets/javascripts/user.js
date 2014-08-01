var currentlyClicked = null;

var setHandlers = function(){
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
  console.log(node, id);
  $firstNode = $("#"+currentlyClicked);
  if(currentlyClicked == null || currentlyClicked == id){
    currentlyClicked = id;
    $firstNode.addClass(".active");
  } else{
    $new = $("#"+id);
    swapNodes($firstNode[0], $new[0]);
    currentlyClicked = null;
  }  
};

//Taken from Bobince's answer at: https://stackoverflow.com/questions/698301/is-there-a-native-jquery-function-to-switch-elements
var swapNodes = function(a, b){
  var aparent= a.parentNode;
    var asibling= a.nextSibling===b? a : a.nextSibling;
    b.parentNode.insertBefore(a, b);
    aparent.insertBefore(b, asibling);
};

$(function(){
  setHandlers();
});
