[![Build Status](https://travis-ci.org/ishakir/footbawwl.svg)](https://travis-ci.org/ishakir/footbawwl)
[![Code Climate](https://codeclimate.com/github/ishakir/footbawwl.png)](https://codeclimate.com/github/ishakir/footbawwl)

Shakitz NFL Fantasy Football for Rails
======================================


What is it?
===========
 
A rails application that manages an NFL fantasy league.

It allows users to sign up and choose a team name, and pick a team. A users team can be edited by either trading directly with other players or bidding for unpicked players on the waver wire. The system automatically loads stats from NFL games so that players scores are up-to-date, and a league table is displayed on the front-end. Head-to-head fixtures can also be generated so that very user has a direct opponent in each game week, giving a second way of ranking the teams.

Installation
============

You will need [rails](http://rubyonrails.org/download) before you can do anything. Once you have done that:

Clone the repository:

    git clone git://github.com/ishakir/footbawwl

Change into the directory created:

    cd footbawwl

Install all the necessary gems

    (sudo) bundle install
    
Install a javascript runtime

    sudo apt-get install nodejs

Start the rails server

    rails server

Contributing
============

If you're interested in contributing please get in contact with ishakir or MikeSpitz, we're putting this together in our spare time, so any help would be most welcome!

We use the standard rails testing frameworks in minitest for unit and rubocop for static analysis, these and a good conversation are the criteria for a commit. In order to check that any changes are good run our custom function validation rake task:

    rake validate

We use magic_encoding to insert the UTF-8 header into the ruby files, so if rubocop returns complaining about a missing utf-8 encoding comment, run:

    magic_encoding
    
<Stafford4President>
