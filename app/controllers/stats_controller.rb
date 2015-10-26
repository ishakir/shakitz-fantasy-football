class StatsController < ApplicationController
	def show
		current_game_week = WithGameWeek.current_game_week
		all_game_week_teams = User.all.map do |user|
			(1 .. current_game_week).map do |game_week|
				user.team_for_game_week(game_week)
			end
		end

		@bench_greater_than_team = all_game_week_teams.flatten.select do |game_week_team|
			game_week_team.bench_points > game_week_team.points
		end

		@bench_greater_than_one_hundred = all_game_week_teams.flatten.select do |game_week_team|
			game_week_team.bench_points > 100
		end

		rows_hash = Hash.new
		all_game_week_teams.each do |game_week_teams|
			rows_hash[game_week_teams[0].user] = {
				total_bench_points: game_week_teams.map{ |game_week_team| game_week_team.bench_points }.sum,
				wins: 0
			}
		end

		(1 ... current_game_week).each do |game_week|
			user = User.all.map{|user| user.team_for_game_week(game_week)}.max_by{|game_week_team| game_week_team.bench_points}.user
			puts user
			rows_hash[user][:wins] = rows_hash[user][:wins] + 1
		end

		@rows = rows_hash.map do |user, hash|
			hash["user"] = user
			hash
		end.sort_by do |hash|
			hash["total_bench_points"]
		end

		@points = Hash[
			User.all.each_with_index.map do |user, index| 
				sum = 0
				[
					user.name, 
					(1 .. current_game_week).map do |game_week|
						user.team_for_game_week(game_week).points 
					end.map do |points|
						# index + 1 is the gameweek number
						sum += (points / (index + 1))
					end
				]
			end
		]
	end
end
