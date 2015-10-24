var CommentBoard = React.createClass({

  getInitialState: function(){
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
      }
    }.bind(this));
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
        <CommentSubmit url={this.props.post}/>
      </div>
    );
  }
});
