import nflgame
import argparse
import os
import requests
import json

def add_stat_to_dictionary(nflgame_name, footbawwl_name, player, stats_dict):
    if nflgame_name in player.__dict__:
        stats_dict[footbawwl_name] = player.__dict__[nflgame_name]

def generate_passing_stats_dict(player):
    passing_stats_dict = {}
    add_stat_to_dictionary('passing_yds', 'passing_yards', player, passing_stats_dict)
    add_stat_to_dictionary('passing_tds', 'passing_tds', player, passing_stats_dict)
    add_stat_to_dictionary('passing_twoptm', 'passing_twoptm', player, passing_stats_dict)
    return passing_stats_dict

def generate_rushing_stats_dict(player):
    rushing_stats_dict = {}
    add_stat_to_dictionary('rushing_yds', 'rushing_yards', player, rushing_stats_dict)
    add_stat_to_dictionary('rushing_tds', 'rushing_tds', player, rushing_stats_dict)
    add_stat_to_dictionary('rushing_twoptm', 'rushing_twoptm', player, rushing_stats_dict)
    return rushing_stats_dict

def generate_receiving_stats_dict(player):
    receiving_stats_dict = {}
    add_stat_to_dictionary('receiving_yds', 'receiving_yards', player, receiving_stats_dict)
    add_stat_to_dictionary('receiving_tds', 'receiving_tds', player, receiving_stats_dict)
    add_stat_to_dictionary('receiving_twoptm', 'receiving_twoptm', player, receiving_stats_dict)
    return receiving_stats_dict

def generate_kicking_stats_dict(player):
    kicking_stats_dict = {}
    add_stat_to_dictionary('kicking_fgm', 'field_goals_kicked', player, kicking_stats_dict)
    add_stat_to_dictionary('kicking_xpmade', 'extra_points_kicked', player, kicking_stats_dict)
    return kicking_stats_dict

def process_player(player):
    # Create a dictionary for this player
    player_dictionary = {
        'player': {
            'id_info': {
                'type': player.guess_position,
                'id': player.playerid,
                'team': player.team,
                'name': player.name
            },
            'stats': {
                'passing_stats': generate_passing_stats_dict(player),
                'rushing_stats': generate_rushing_stats_dict(player),
                'receiving_stats': generate_receiving_stats_dict(player),
                'kicking_stats': generate_kicking_stats_dict(player)
            }
        }
    }

    return player_dictionary

def process_players_for_games(games):
    teams = []
    players = {}
    for game in games:
        for player in game.max_player_stats():
            if player.guess_position in ['K', 'QB', 'RB', 'WR', 'TE']:
                if player.team not in teams:
                    teams.append(player.team)
                if player.playerid not in players:
                    players[player.playerid] = {
                        'id': player.playerid,
                        'name': player.name,
                        'team': player.team,
                        'type': player.guess_position
                    }
    # Upload Defence for each team
    for team in teams:
        headers = {'Content-type': 'application/json'}
        print "Uploading "+team+" Defence"
        response = requests.post(
            'http://localhost:3000/nfl_player',
            data = json.dumps({
                'team': team,
                'type': 'D'
            }),
            headers = headers
        )
    for playerid in players:
        headers = {'Content-type': 'application/json'}
        print "Uploading "+players[playerid]['name']
        response = requests.post(
            'http://localhost:3000/nfl_player',
            data = json.dumps(players[playerid]),
            headers = headers
        )



def process_stats_for_game(game, game_week):
    for player in game.max_player_stats():
        if player.guess_position in ['K', 'QB', 'RB', 'WR', 'TE']:
            dict = process_player(player)
            headers = {'Content-type': 'application/json', 'Accept': 'application/json'}
            response = requests.post('http://localhost:3000/nfl_player/stats/'+str(game_week), data=json.dumps(dict), headers=headers)
            if response.status_code != 200:
                print "ERROR: Got response code "+str(response.status_code)+" from player "+player.name+" in team "+player.team
            response_json = json.loads(response.text)
            for message in response_json['messages']:
                print message['message']

# First grab the command line arguments
parser = argparse.ArgumentParser()
parser.add_argument('--year', required = True, type = int)
parser.add_argument('--game_week', required = True, type = str)
parser.add_argument('--function', required = True, type = str)    # players, stats
parser.add_argument('--type', required = True, type = str)        # PRE, REG, POST
ns = parser.parse_args()

print ns.game_week
print ns.year
print ns.function
print ns.type

# Now grab all the games in that gameweek
games = None
if ns.game_week == "all" and ns.function == "players":
    games = []
    for week in range(1, 17):
        games = games + nflgame.games(ns.year, week = week, kind = ns.type)
    process_players_for_games(games)
elif ns.game_week == "all" and ns.function == "stats":
    for week in range(1, 17):
        games = nflgame.games(ns.year, week = week, kind = ns.type)
        print "Processing week " + str(week)
        for game in games:
            process_stats_for_game(game, week)
elif ns.function == "players":
    games = nflgame.games(ns.year, week = int(ns.game_week), kind = ns.type)
    process_players_for_games(games)
elif ns.function == "stats":
    games = nflgame.games(ns.year, week = int(ns.game_week), kind = ns.type)
    for game in games:
        process_stats_for_game(game, ns.game_week)