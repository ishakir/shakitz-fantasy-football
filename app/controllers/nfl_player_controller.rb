class NflPlayerController < ApplicationController
  def unpicked
    @players = NflPlayer.all
    picked_players = GameWeekTeamPlayer.all
    
    @unpicked_players = @players.select do |player| 
      !picked_players.any? do |active_player| 
        active_player.match_player.nfl_player_id == player.id
      end
    end    
  end

  def show
    id = params[:id]
    @player = NflPlayer.find(id)
  end
end