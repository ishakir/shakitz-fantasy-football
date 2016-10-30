import footbawwlapi.facade

class Game:
  
  def __init__(self, game, game_week):
    self.game = game
    self.game_week = game_week

  def all_players(self):
    players = self.offensive_players()
    players.extend(self.defensive_players())
    return players

  def offensive_players(self):
    offensive_player_list = []
    for player in self.game.max_player_stats():
      if player.guess_position in ['K', 'QB', 'RB', 'WR', 'TE']:
        offensive_player_list.append(OffencePlayer(player, self.game_week))
    return offensive_player_list

  def defensive_players(self):
    defensive_player_list = []
    defensive_player_list.append(DefencePlayer(self.game, self.game_week, self.game.home))
    defensive_player_list.append(DefencePlayer(self.game, self.game_week, self.game.away))
    return defensive_player_list

class Player:
  def get_api_facade(self, host, port):
    return footbawwlapi.facade.NflPlayerFacade(host, port, self)

class OffencePlayer(Player):
  
  def __init__(self, player, game_week):
    self.player = player
    self.game_week = game_week

    self.name = player.name
    self.team = player.team
    self.type = player.guess_position

    self.playerid = player.playerid

  def id_info(self):
    return {
      'type': self.type,
      'id': self.playerid,
      'team': self.team,
      'name': self.name
    }

  def stats(self):
    return {
      'passing_stats': self.__passing_stats(),
      'rushing_stats': self.__rushing_stats(),
      'receiving_stats': self.__receiving_stats(),
      'kicking_stats': self.__kicking_stats()
    }

  def __passing_stats(self):
    passing_stats_dict = {}
    self.__add_stat_to_dictionary('passing_yds', 'passing_yards', passing_stats_dict)
    self.__add_stat_to_dictionary('passing_tds', 'passing_tds', passing_stats_dict)
    self.__add_stat_to_dictionary('passing_twoptm', 'passing_twoptm', passing_stats_dict)
    self.__add_stat_to_dictionary('passing_sk', 'times_sacked', passing_stats_dict)
    self.__add_stat_to_dictionary('passing_ints', 'interceptions_thrown', passing_stats_dict)
    return passing_stats_dict

  def __rushing_stats(self):
    rushing_stats_dict = {}
    self.__add_stat_to_dictionary('rushing_yds', 'rushing_yards', rushing_stats_dict)
    self.__add_stat_to_dictionary('rushing_tds', 'rushing_tds', rushing_stats_dict)
    self.__add_stat_to_dictionary('rushing_twoptm', 'rushing_twoptm', rushing_stats_dict)
    self.__add_stat_to_dictionary('fumbles_lost', 'fumbles_lost', rushing_stats_dict)
    return rushing_stats_dict

  def __receiving_stats(self):
    receiving_stats_dict = {}
    self.__add_stat_to_dictionary('receiving_yds', 'receiving_yards', receiving_stats_dict)
    self.__add_stat_to_dictionary('receiving_tds', 'receiving_tds', receiving_stats_dict)
    self.__add_stat_to_dictionary('receiving_twoptm', 'receiving_twoptm', receiving_stats_dict)
    return receiving_stats_dict

  def __kicking_stats(self):
    kicking_stats_dict = {}
    self.__add_stat_to_dictionary('kicking_fgm', 'field_goals_kicked', kicking_stats_dict)
    self.__add_stat_to_dictionary('kicking_xpmade', 'extra_points_kicked', kicking_stats_dict)
    return kicking_stats_dict

  def __add_stat_to_dictionary(self, nfl_game_key, footbawwl_key, stats_dict):
    if nfl_game_key in self.player.__dict__:
      stats_dict[footbawwl_key] = self.player.__dict__[nfl_game_key]

class DefencePlayer(Player):

  def __init__(self, game, game_week, team):
    self.game = game
    self.game_week = game_week
    
    self.name = team + " Defence"
    self.team = team
    self.type = 'D'

  def id_info(self):
    return {
      'name': self.name,
      'team': self.team,
      'type': self.type
    }

  def stats(self):
    defensive_sack = 0
    defensive_fumbles = 0
    defensive_touchdowns = 0
    points_conceded = 0
    interceptions_caught = 0

    if self.game.home == self.team:
      points_conceded = self.game.score_away
    else:
      points_conceded = self.game.score_home

    for player in self.game.max_player_stats():
      if player.team == self.team:
        if "defense_tds" in player.__dict__:
          defensive_touchdowns += player.__dict__["defense_tds"]
      else:
        if "passing_sk" in player.__dict__:
          defensive_sack += player.__dict__["passing_sk"]
        if "fumbles_lost" in player.__dict__:
          defensive_fumbles += player.__dict__["fumbles_lost"]
        if "passing_ints" in player.__dict__:
          interceptions_caught += player.__dict__["passing_ints"]
        if "defense_tds" in player.__dict__:
          points_conceded -= 6* player.__dict__["defense_tds"]

    stats_dict = {
      'rushing_stats': {
        'defense_touchdowns': defensive_touchdowns,
        'sacks_made': defensive_sack,
        'fumbles_won': defensive_fumbles,
        'points_conceded': points_conceded,
        'interceptions_caught': interceptions_caught
      }
    }

    return stats_dict
