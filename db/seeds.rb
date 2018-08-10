# -*- encoding : utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
[
  "LAC", "HOU", "WAS", "PHI", "NYG", "DAL", "SF" , "GB" ,
  "LA", "ARI", "TEN", "PIT", "ATL", "NO" , "TB" , "NYJ",
  "KC" , "JAX", "OAK", "IND", "MIN", "DET", "CLE", "MIA",
  "CHI", "CIN", "DEN", "BAL", "BUF", "NE" , "SEA", "CAR"
].each do |team|
  NflTeam.create!(name: team)
end

NflPlayerType::ALLOWED_TYPES.each do |position|
  NflPlayerType.create!(position_type: position)
end

1.upto(Settings.number_of_gameweeks) do |number|
  GameWeek.create!(number: number)
end
