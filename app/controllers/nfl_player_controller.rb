class NflPlayerController < ApplicationController
  
  def unpicked
    @players = NflPlayer.all
  end
  
end
