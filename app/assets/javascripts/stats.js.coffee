# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# legendTemplate = "<div class="btn-group-vertical" role="group">
#                     <% for (var i=0; i<datasets.length; i++){%>
#                       <button type="button"
#                               class="btn btn-default dropdown-toggle"
#                               data-toggle="dropdown"
#                               aria-expanded="false" disabled="true" style="color: <%=datasets[i].strokeColor%>;">
#                       <%if(datasets[i].label){%>
#                         <%=datasets[i].label%>
#                       <%}%>
#                     <%}%>
#                   </div>"

# fillColor = "rgba(220,220,220,0)"
# pointColor = "rgba(0,0,0,0)"
# pointStrokeColor = "#fff"

# # TODO - need two more colors for max no. users of 8
# strokeColors = [
#   "rgb(0,0,0)"
#   "rgb(255,0,0)"
#   "rgb(0,255,0)"
#   "rgb(0,0,255)"
#   "rgb(0,255,255)"
#   "rgb(255,0,255)"
# ]

# users = [
#   {
#     id : 1,
#     name : "Imran",
#     team_name : "Crabbers n' Co",
#     points : {
#       total : 1172,
#       url : "/users/1/points"
#     },
#     fixtures : {
#       record : "5-5",
#       url : "/users/1/fixtures"
#     },
#     game_weeks : {
#       1 : { url : "/users/1/game_week/1" },
#       2 : { url : "/users/1/game_week/2" },
#       3 : { url : "/users/1/game_week/3" },
#       4 : { url : "/users/1/game_week/4" },
#       5 : { url : "/users/1/game_week/5" },
#       6 : { url : "/users/1/game_week/6" },
#       7 : { url : "/users/1/game_week/7" },
#       8 : { url : "/users/1/game_week/8" },
#       9 : { url : "/users/1/game_week/9" },
#       10 : { url : "/users/1/game_week/10" },
#       11 : { url : "/users/1/game_week/11" },
#       12 : { url : "/users/1/game_week/12" }
#     },
#     positions : {
#       current : 4,
#       url : "/users/1/positions"
#     }
#   },
#   {
#     id : 2,
#     name : "Mike",
#     team_name : "Jew Suh Kuhns",
#     points : {
#       total : 1259,
#       url : "/users/2/points"
#     },
#     fixtures : {
#       record : "6-4",
#       url : "/users/2/fixtures"
#     },
#     game_weeks : {
#       1 : { url : "/users/2/game_week/1" },
#       2 : { url : "/users/2/game_week/2" },
#       3 : { url : "/users/2/game_week/3" },
#       4 : { url : "/users/2/game_week/4" },
#       5 : { url : "/users/2/game_week/5" },
#       6 : { url : "/users/2/game_week/6" },
#       7 : { url : "/users/2/game_week/7" },
#       8 : { url : "/users/2/game_week/8" },
#       9 : { url : "/users/2/game_week/9" },
#       10 : { url : "/users/2/game_week/10" },
#       11 : { url : "/users/2/game_week/11" },
#       12 : { url : "/users/2/game_week/12" }
#     },
#     positions : {
#       current : 2,
#       url : "/users/2/positions"
#     }
#   },
#   {
#     id : 3,
#     name : "Rich",
#     team_name : "First Down Syndrome",
#     points : {
#       total : 1331,
#       url : "/users/3/points"
#     },
#     fixtures : {
#       record : "6-4",
#       url : "/users/3/fixtures"
#     },
#     game_weeks : {
#       1 : { url : "/users/3/game_week/1" },
#       2 : { url : "/users/3/game_week/2" },
#       3 : { url : "/users/3/game_week/3" },
#       4 : { url : "/users/3/game_week/4" },
#       5 : { url : "/users/3/game_week/5" },
#       6 : { url : "/users/3/game_week/6" },
#       7 : { url : "/users/3/game_week/7" },
#       8 : { url : "/users/3/game_week/8" },
#       9 : { url : "/users/3/game_week/9" },
#       10 : { url : "/users/3/game_week/10" },
#       11 : { url : "/users/3/game_week/11" },
#       12 : { url : "/users/3/game_week/12" }
#     },
#     positions : {
#       current : 1,
#       url : "/users/3/positions"
#     }
#   },
#   {
#     id : 4,
#     name : "James",
#     team_name : "Henne Dream Will Do",
#     points : {
#       total : 1143,
#       url : "/users/4/points"
#     },
#     fixtures : {
#       record : "6-4",
#       url : "/users/4/fixtures"
#     },
#     game_weeks : {
#       1 : { url : "/users/4/game_week/1" },
#       2 : { url : "/users/4/game_week/2" },
#       3 : { url : "/users/4/game_week/3" },
#       4 : { url : "/users/4/game_week/4" },
#       5 : { url : "/users/4/game_week/5" },
#       6 : { url : "/users/4/game_week/6" },
#       7 : { url : "/users/4/game_week/7" },
#       8 : { url : "/users/4/game_week/8" },
#       9 : { url : "/users/4/game_week/9" },
#       10 : { url : "/users/4/game_week/10" },
#       11 : { url : "/users/4/game_week/11" },
#       12 : { url : "/users/4/game_week/12" }
#     },
#     positions : {
#       current : 5,
#       url : "/users/4/positions"
#     }
#   },
#   {
#     id : 5,
#     name : "Andy",
#     team_name : "Gotta Catch Jamaal",
#     points : {
#       total : 1206,
#       url : "/users/5/points"
#     },
#     fixtures : {
#       record : "5-5",
#       url : "/users/5/fixtures"
#     },
#     game_weeks : {
#       1 : { url : "/users/5/game_week/1" },
#       2 : { url : "/users/5/game_week/2" },
#       3 : { url : "/users/5/game_week/3" },
#       4 : { url : "/users/5/game_week/4" },
#       5 : { url : "/users/5/game_week/5" },
#       6 : { url : "/users/5/game_week/6" },
#       7 : { url : "/users/5/game_week/7" },
#       8 : { url : "/users/5/game_week/8" },
#       9 : { url : "/users/5/game_week/9" },
#       10 : { url : "/users/5/game_week/10" },
#       11 : { url : "/users/5/game_week/11" },
#       12 : { url : "/users/5/game_week/12" }
#     },
#     positions : {
#       current : 3,
#       url : "/users/5/positions"
#     }
#   },
#   {
#     id : 6,
#     name : "Sam",
#     team_name : "no sponsor",
#     points : {
#       total : 1103,
#       url : "/users/6/points"
#     },
#     fixtures : {
#       record : "2-8",
#       url : "/users/6/fixtures"
#     },
#     game_weeks : {
#       1 : { url : "/users/6/game_week/1" },
#       2 : { url : "/users/6/game_week/2" },
#       3 : { url : "/users/6/game_week/3" },
#       4 : { url : "/users/6/game_week/4" },
#       5 : { url : "/users/6/game_week/5" },
#       6 : { url : "/users/6/game_week/6" },
#       7 : { url : "/users/6/game_week/7" },
#       8 : { url : "/users/6/game_week/8" },
#       9 : { url : "/users/6/game_week/9" },
#       10 : { url : "/users/6/game_week/10" },
#       11 : { url : "/users/6/game_week/11" },
#       12 : { url : "/users/6/game_week/12" }
#     },
#     positions : {
#       current : 6,
#       url : "/users/6/positions"
#     }
#   }
# ]

# points_for_user = (id) ->
#   switch id
#     when 1 then {
#       user : {
#         id : 1,
#         name : "Imran",
#         team_name : "Crabbers n' Co",
#         url : "users/1"
#       },
#       points : {
#         total : 1172,
#         game_weeks : {
#           1 : 157,
#           2 : 91,
#           3 : 62,
#           4 : 102,
#           5 : 68,
#           6 : 113,
#           7 : 81,
#           8 : 103,
#           9 : 107,
#           10 : 118,
#           11 : 102,
#           12 : 68
#         }
#       }
#     }
#     when 2 then {
#       user : {
#         id : 2,
#         name : "Mike",
#         team_name : "Jew Suh Kuhns",
#         url : "users/2"
#       },
#       points : {
#         total : 1259,
#         game_weeks : {
#           1 : 89,
#           2 : 105,
#           3 : 89,
#           4 : 149,
#           5 : 84,
#           6 : 102,
#           7 : 108,
#           8 : 118,
#           9 : 110,
#           10 : 122,
#           11 : 87,
#           12 : 96
#         }
#       }
#     }
#     when 3 then {
#       user : {
#         id : 3,
#         name : "Rich",
#         team_name : "First Down Syndrome",
#         url : "users/3"
#       },
#       points : {
#         total : 1331,
#         game_weeks : {
#           1 : 90,
#           2 : 96,
#           3 : 100,
#           4 : 85,
#           5 : 146,
#           6 : 133,
#           7 : 111,
#           8 : 145,
#           9 : 106,
#           10 : 125,
#           11 : 82,
#           12 : 112
#         }
#       }
#     }
#     when 4 then {
#       user : {
#         id : 4,
#         name : "James",
#         team_name : "Henne Dream Will Do",
#         url : "users/4"
#       },
#       points : {
#         total : 1143,
#         game_weeks : {
#           1 : 82,
#           2 : 72,
#           3 : 86,
#           4 : 122,
#           5 : 74,
#           6 : 91,
#           7 : 78,
#           8 : 146,
#           9 : 99,
#           10 : 96,
#           11 : 79,
#           12 : 118
#         }
#       }
#     }
#     when 5 then {
#       user : {
#         id : 5,
#         name : "Andy",
#         team_name : "Gotta Catch Jamaal",
#         url : "users/5"
#       },
#       points : {
#         total : 1206,
#         game_weeks : {
#           1 : 64,
#           2 : 82,
#           3 : 74,
#           4 : 84,
#           5 : 119,
#           6 : 124,
#           7 : 82,
#           8 : 137,
#           9 : 82,
#           10 : 109,
#           11 : 126,
#           12 : 123
#         }
#       }
#     }
#     when 6 then {
#       user : {
#         id : 6,
#         name : "Sam",
#         team_name : "no sponsor",
#         url : "users/6"
#       },
#       points : {
#         total : 1103,
#         game_weeks : {
#           1 : 118,
#           2 : 126,
#           3 : 106,
#           4 : 41,
#           5 : 133,
#           6 : 115,
#           7 : 107,
#           8 : 82,
#           9 : 75,
#           10 : 61,
#           11 : 73,
#           12 : 66
#         }
#       }
#     }

# no_gameweeks = 12

# jQuery ->
#   user_points = users.map (user) -> points_for_user(user.id)

#   # Points Graph!!
#   points_data = user_points.map (user, index) ->
#     data = [1 .. no_gameweeks].map (game_week) -> user.points.game_weeks[game_week]
#     {
#       label : user.user.name,
#       fillColor : fillColor,
#       strokeColor : strokeColors[index],
#       pointColor : pointColor,
#       pointStrokeColor : pointStrokeColor,
#       data : data
#     }

#   pointsData = {
#     labels : [1 .. no_gameweeks],
#     datasets : points_data
#   }

#   pointsChart = new Chart($("#pointsChart").get(0).getContext("2d")).Line(
#     pointsData,
#     {
#       showTooltips : false,
#       bezierCurveTension: 0.1,
#       legendTemplate : legendTemplate,
#       responsive : true,
#       pointDot : false
#     }
#   )
#   jQuery('#pointsChartLegend').html(pointsChart.generateLegend())

# jQuery ->
#   user_points = users.map (user) -> points_for_user(user.id)

#   # Cumulative Points Graph!!
#   cumulative_points_data = user_points.map (user, index) ->
#     data = [0]
#     for game_week in [1 .. no_gameweeks]
#       do (game_week) ->
#         data[game_week] = data[game_week - 1] + user.points.game_weeks[game_week]
#     {
#       label : user.user.name,
#       fillColor : fillColor,
#       strokeColor : strokeColors[index],
#       pointColor : pointColor,
#       pointStrokeColor : pointStrokeColor,
#       data : data
#     }

#   cumulativePointsData = {
#     labels : [0 .. no_gameweeks],
#     datasets : cumulative_points_data
#   }

#   pointsChart = new Chart($("#cumulativePointsChart").get(0).getContext("2d")).Line(
#     cumulativePointsData,
#     {
#       showTooltips : false,
#       legendTemplate : legendTemplate,
#       responsive : true,
#       pointDot : false
#     }
#   )
#   jQuery('#cumulativePointsChartLegend').html(pointsChart.generateLegend())

# jQuery ->
#   randomData = {
#     labels : [1 .. 11],
#     datasets : [
#       {
#         label : "Imran",
#         fillColor : "rgba(220,220,220,0)",
#         strokeColor : "rgba(0,0,0,1)",
#         pointColor : "rgba(0,0,0,0)",
#         pointStrokeColor : "#fff",
#         data : [5, 5, 4, 4, 2, 2, 2, 2, 2, 3, 3]
#       },
#       {
#         label : "Sam",
#         fillColor : "rgba(220,220,220,0)",
#         strokeColor : "rgba(255,0,0,1)",
#         pointColor : "rgba(255,0,0,0)",
#         pointStrokeColor : "#fff",
#         data : [4, 4, 5, 3, 5, 4, 4, 3, 3, 2, 1]
#       },
#       {
#         label : "Rich",
#         fillColor : "rgba(220,220,220,0)",
#         strokeColor : "rgba(0,255,0,1)",
#         pointColor : "rgba(255,0,0,0)",
#         pointStrokeColor : "#fff",
#         data : [3, 2, 3, 2, 4, 5, 5, 5, 5, 5, 5]
#       },
#       {
#         label : "Mike",
#         fillColor : "rgba(220,220,220,0)",
#         strokeColor : "rgba(0,0,255,1)",
#         pointColor : "rgba(255,0,0,0)",
#         pointStrokeColor : "#fff",
#         data : [2, 3, 2, 5, 3, 3, 3, 4, 4, 4, 4]
#       },
#       {
#         label : "James",
#         fillColor : "rgba(220,220,220,0)",
#         strokeColor : "rgba(0,255,255,1)",
#         pointColor : "rgba(255,0,0,0)",
#         pointStrokeColor : "#fff",
#         data : [1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0]
#       },
#       {
#         label : "Andy",
#         fillColor : "rgba(220,220,220,0)",
#         strokeColor : "rgba(255,0,255,1)",
#         pointColor : "rgba(255,0,0,0)",
#         pointStrokeColor : "#fff",
#         data : [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2]
#       }
#     ]
#   }

#   positionChart = new Chart($("#positionChart").get(0).getContext("2d")).Line(
#     randomData,
#     {
#       showTooltips : false,
#       bezierCurveTension : 0.05,
#       legendTemplate : legendTemplate,
#       scaleLabel : "<%= 6 - value %>",
#       response : true,
#       pointDot : false
#     }
#   )
#   jQuery('#positionChartLegend').html(positionChart.generateLegend())

total_users = 0
no_users_processed = 0

weekly_data = {}
user_data = {}

benches_exceeding_100_points = []
benches_that_beat_team = []

ready = ->
  $.getJSON "/api/users", {}, (users, response) ->
    total_users = users.length
    process_user(user) for user in users

$(document).ready(ready)
$(document).on('page:load', ready)

process_user = (user) ->
  $.getJSON user.points.url, {}, (user, response) ->
    user_data[user.user.id] = {
      name: user.user.name,
      team_name: user.user.team_name,
      points: user.points.total_bench
    }

    for own game_week of user.points.game_weeks
      game_week_points = user.points.game_weeks[game_week]
      continue if game_week_points.bench_points == 0

      weekly_data[game_week] = {} if !weekly_data[game_week]
      weekly_data[game_week][user.user.id] = game_week_points.bench_points

      benches_exceeding_100_points.push({
        user: user.user.name,
        game_week: game_week,
        points: game_week_points.bench_points
      }) if game_week_points.bench_points > 100

      benches_that_beat_team.push({
        user: user.user.name,
        game_week: game_week,
        bench_points: game_week_points.bench_points,
        points: game_week_points.points
      }) if game_week_points.bench_points > game_week_points.points
    
    no_users_processed++
    calculate_wins() if(total_users == no_users_processed)

calculate_wins = ->
  for own game_week of weekly_data
    best_user = 0
    best_bench = 0
    for own user of weekly_data[game_week]
      if weekly_data[game_week][user] > best_bench
        best_user = user
        best_bench = weekly_data[game_week][user]
    previous_wins = user_data[best_user].wins
    if !previous_wins
      user_data[best_user].wins = 1
    else
      user_data[best_user].wins = previous_wins + 1

  render_page()

render_page = ->
  user_array = []
  for own user of user_data
    user_array.push(user_data[user])

  _(user_array).sortBy (user) -> user.wins
  add_elements_to_table(user_array)
  add_benches_exceeding_100_points()
  add_benches_that_beat_team()

add_elements_to_table = (users) ->
  for user, index in users
    user.wins = 0 unless user.wins
    table_start
    if(index == 0)
      table_start = "<tr class=\"success\">"
    else if(index == users.length - 1)
      table_start = "<tr class=\"danger\">"
    else
      table_start = "<tr>"
    table_row = """
                #{table_start}
                  <td>#{user.name}</td>
                  <td>#{user.team_name}</td>
                  <td>#{user.points}</td>
                  <td>#{user.wins}</td>
                </tr>"""
    $("#benchTable tr:last").after(table_row)

add_benches_exceeding_100_points = ->
  show_no_100_bench() unless benches_exceeding_100_points.length
  for game_week_team in benches_exceeding_100_points
    add_bench_exceeding_100_points(game_week_team)

add_benches_that_beat_team = ->
  show_no_winning_benches() unless benches_that_beat_team.length
  for game_week_team in benches_that_beat_team
    add_bench_that_beat_team(game_week_team)

add_bench_exceeding_100_points = (info) ->
  sentence = "In week #{info.game_week} #{info.user}'s bench scored #{info.points} points!"
  $('#noHundredList').append("<li class=\"list-group-item\">#{sentence}</li>")
  $.bootstrapSortable()

add_bench_that_beat_team = (info) ->
  sentence = "In week #{info.game_week} #{info.user}'s bench scored #{info.bench_points} points,
              beating their active team (#{info.points} points)"
  $('#betterList').append("<li class=\"list-group-item\">#{sentence}</li>")
  $.bootstrapSortable()

show_no_100_bench = ->
  $('#noHundredPointBench').show()
  $('#noHundredWellDone').show()

show_no_winning_benches = ->
  $('#noBenchesBetterThanTeam').show()
  $('#betterWellDone').show()