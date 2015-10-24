var CommentSubmit = React.createClass({
  handleKeyDown: function(event){
    if(event.key === 'Enter'){
      var comment = event.target.value;
      $.ajax({
        type: 'POST',
        url: this.props.url,
        data: {
          request: {
            user: this.props.user_id,
            text: comment,
            timestamp: new Date().getTime()
          }
        }
      }).done(function(data){
        $('.input').val('');
      }).fail(function(xhr){
        console.log(xhr);
      });
    }
  },

  render: function() {
    return (
      <div>
        <input onKeyPress={this.handleKeyDown} className='input' type="text" placeholder="Write your message here... "/>
      </div>
    );
  }
});
