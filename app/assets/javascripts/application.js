// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require twitter/typeahead.min
//= require spin
//= require less-1.3.3.min
//= require moment.min
//= require bootstrap-sortable
//= require bootstrap-select
//= require underscore

var initPlayerSuggestions = function(data, callback) {
  // constructs the suggestion engine
  var playerList = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    limit: 32,
    local: $.map(data, function(p) { return { value: p.player.name, id: p.player.id, team: p.team }; })
  });
  // kicks off the loading/processing of `local` and `prefetch`
  playerList.initialize();

  $('#bloodhound .typeahead').typeahead({
    hint: true,
      highlight: true,
    minLength: 1
  }, {
    name: 'nfl_players',
      displayKey: 'value',
      source: playerList.ttAdapter(),
      templates: {
        suggestion: function (datum) {
               return datum.value + " <span class=\"text-muted small\"> in " + datum.team + "</span>";
        }
      }
  }).bind('typeahead:selected', function($e, player){
    callback(player);
  });
};