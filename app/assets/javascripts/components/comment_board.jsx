var CommentBoard = React.createClass({

  getInitialState: function(){
    this.scrollToBottom();
    return {
      comments: []
    };
  },

  loadCommentsFromServer: function() {
    $.get(this.props.url, function(result){
      var comments = result;
      if(this.isMounted()){
        this.setState({
          comments: comments
        });
        this.scrollToBottom();
        this.updateLocalTimestamp();
      }
    }.bind(this));
  },

  updateLocalTimestamp: function() {
    var lastComment = this.state.comments[this.state.comments.length-1].timestamp;
    localStorage.setItem('lastComment', new Date(Math.floor(lastComment)));
  },

  clearBadge: function() {
    $('.smack-badge').html('');
  },

  scrollToBottom: function() {
	  var board = $('#comment-board');
	  board.scrollTop(board.prop("scrollHeight"));
  },

  componentDidMount: function() {
    this.clearBadge();
    this.loadCommentsFromServer();
    setInterval(this.loadCommentsFromServer, this.props.pollInterval);
  },

  render: function() {
    return (
      <div id="comment-board">
        {this.state.comments.map(function(commentData){
          return <Comment key={commentData.id} data={commentData} />;
        })}
        <CommentSubmit url={this.props.post} user_id={this.props.user_id}/>
      </div>
    );
  }
});
