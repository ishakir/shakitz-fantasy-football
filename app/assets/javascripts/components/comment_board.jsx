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
      }
    }.bind(this));
  },

  scrollToBottom: function() {
	  var board = $('#comment-board');
	  board.scrollTop(board.prop("scrollHeight"));
  },

  componentDidMount: function() {
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
