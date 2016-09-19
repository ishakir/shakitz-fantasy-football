module BestTeam
  BEST_TEAM_SIZE = 10

  BEST_TEAM_DEFINITION = {
    NflPlayerType::QB => {
      min: 2,
      max: 2
    },
    NflPlayerType::RB => {
      min: 2,
      max: 2
    },
    NflPlayerType::WR => {
      min: 2,
      max: 3
    },
    NflPlayerType::TE => {
      min: 1,
      max: 2
    },
    NflPlayerType::K => {
      min: 1,
      max: 2
    },
    NflPlayerType::D => {
      min: 1,
      max: 1
    }
  }.freeze

  # Players should be an NflPlayer -> points hash
  def self.find_ten_best_players(players)
    player_arrays = BEST_TEAM_DEFINITION.keys.reduce(best: [], remaining: []) do |player_arrays_acc, player_type|
      add_players_of_type(player_type, player_arrays_acc, players)
    end

    best_players = player_arrays[:best]
    remaining_players = player_arrays[:remaining]

    best_players.concat(remaining_players.sort_by { |_player, points| points }.last(BEST_TEAM_SIZE - best_players.size))
  end

  def self.add_players_of_type(player_type, player_arrays, players)
    best_players = player_arrays[:best]
    remaining_players = player_arrays[:remaining]

    max = BEST_TEAM_DEFINITION[player_type][:max]
    min = BEST_TEAM_DEFINITION[player_type][:min]

    best_of_type = find_top_of_type(player_type, max, players)
    best_players.concat(best_of_type[0..(min - 1)])
    remaining_players.concat(best_of_type[min..(max - 1)])
    { best: best_players, remaining: remaining_players }
  end

  def self.find_top_of_type(type, number, players)
    only_of_this_type = players.select do |nfl_player, _points|
      nfl_player.nfl_player_type.position_type == type.to_s
    end
    sorted = only_of_this_type.sort_by { |_nfl_player, points| -points }
    sorted[0, number]
  end
end
