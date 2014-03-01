class NflPlayerController < ApplicationController
  
  def unpicked
    @players = NflPlayer.all
  end
  
  def show
    
    id = params[:id]
    @player = NflPlayer.find(id)
    
  end
  
end
