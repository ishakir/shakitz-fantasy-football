import json
import requests

# Define some constant to be used throughout
BASE_URL = "http://localhost:3000"
JSON_REQUEST_HEADERS = {
  'Content-type': 'application/json'
}
JSON_REQUEST_RESPONSE_HEADERS = {
  'Content-type': 'application/json', 
  'Accept': 'application/json'
}

class APIFacade(object):

  def make_call_to(self, path, dict, headers):
    data = json.dumps(dict)
    full_url = BASE_URL + path
    return requests.post(
      full_url,
      data = data,
      headers = headers,
      verify = False
    )

class NflPlayerFacade(APIFacade):

  def __init__(self, player):
    self.player = player

  def create(self):
    return super(NflPlayerFacade, self).make_call_to(
      "/nfl_player", 
      self.player.id_info(),
      JSON_REQUEST_HEADERS
    )

  def update_stats(self):
    path = "/nfl_player/stats/"+str(self.player.game_week)
    stats_data = {
      'player': {
        'id_info': self.player.id_info(),
        'stats': self.player.stats()
      }
    }
    return super(NflPlayerFacade, self).make_call_to(
      path, 
      stats_data,
      JSON_REQUEST_RESPONSE_HEADERS
    )
