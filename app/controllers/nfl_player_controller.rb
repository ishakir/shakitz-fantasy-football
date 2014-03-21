class NflPlayerController < ApplicationController
  
  def unpicked
    @players = NflPlayer.all
  end
  
  def show
    
    id = params[:id]
    @player = NflPlayer.find(id)
    
  end
  
  def backdoor
    
    NflPlayer.create(:name => "Marshawn Lunch")
    NflPlayer.create(:name => "Matthew Staffpick")
    
  end
  
end
