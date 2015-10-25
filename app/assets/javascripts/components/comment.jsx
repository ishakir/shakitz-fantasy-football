var Comment = React.createClass({
  convertTime: function(){
    return new Date(this.props.data.timestamp).toUTCString();
  },
  
  render: function() {
    var time = '' + this.convertTime();
    return (
      <div className="comment-container">
        <div className="name">
          <img className="image-rank" />
          <span className="user-name">{this.props.data.user_name}</span>
          <span className="timestamp">{time}</span>
        </div>
        <div className="comment">
          {this.props.data.text}
        </div>
      </div>
    );
  }
});
