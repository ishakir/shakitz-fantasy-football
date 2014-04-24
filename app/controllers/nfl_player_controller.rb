class NflPlayerController < ApplicationController
  def unpicked
    @players = NflPlayer.all
    picked_players = GameWeekTeamPlayer.all
    unpicked_set = Set.new
    
    @players.each do |player|
      player_has_been_picked = false
      picked_players.each do |p|
        if(player.id == p.match_player.nfl_player_id)
          player_has_been_picked = true
        end  
      end
      if(!player_has_been_picked)
        unpicked_set.add(player)
      end
    end
    
    @unpicked_players = unpicked_set
  end

  def show
    id = params[:id]
    @player = NflPlayer.find(id)
  end
end