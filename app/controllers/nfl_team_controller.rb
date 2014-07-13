# -*- encoding : utf-8 -*-
class NflTeamController < ApplicationController
  def all
    @teams = NflTeam.all
  end

  def show
    id = params[:id]
    @team = NflTeam.find(id)
  end
end
