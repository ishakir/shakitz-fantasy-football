import json
import nflgame

from footbawwlapi.game import Game

def create_all_players(host, port, year, kind, game_weeks):
  games = []
  for week in game_weeks:
    print "Finding games for: (year = '{}', week = '{}', kind = '{}')".format(year, week, kind)
    found_games = nflgame.games(year, week = week, kind = kind)
    print "Found {} games".format(str(len(games)))
    for game in found_games:
      games.append(Game(game, week))

  if not len(games) > 0:
    raise RuntimeError("Couldn't find any {}-games in {}, did you get the year right?".format(kind, year))

  offensive_players = {}
  defensive_players = {}

  for game in games:
    for player in game.offensive_players():
      if player.playerid not in offensive_players:
        offensive_players[player.playerid] = player
    for player in game.defensive_players():
      if player.team not in defensive_players:
        defensive_players[player.team] = player

  all_players = dict(offensive_players.items() + defensive_players.items())
  total_no_players = len(all_players.keys())
  counter = 1
  for key, value in all_players.iteritems():
    print "Uploading player "+value.name+" "+str(counter)+"/"+str(total_no_players)
    response = value.get_api_facade(host, port).create()
    if response.status_code != 200:
      print "Error creating player "+player.name+" code was "+str(response.status_code)
    counter += 1

def update_player_stats(host, port, player):
  print "Updating stats for player {} ({})".format(player.name, player.playerid if hasattr(player, 'playerid') else '')
  api_facade = player.get_api_facade(host, port)
  response = api_facade.update_stats()
  if response.status_code != 200:
    print "ERROR: Got response code "+str(response.status_code)+" from player "+player.name+" in team "+player.team
    if response.status_code == 404:
      print "Creating player "+player.name
      api_facade.create()
      update_player_stats(host, port, player)
    else:
      try:
        response_json = json.loads(response.text)
      except ValueError as e:
        print "Unable to parse response as json!"
        print response.text
        raise
      print response_json
      for message in response_json['messages']:
        print message['message']
    


def update_stats(host, port, year, kind, game_week):
  games = nflgame.games(year, week = game_week, kind = kind)

  for nfl_game in games:
    game = Game(nfl_game, game_week)
    for player in game.all_players():
      update_player_stats(host, port, player)
      