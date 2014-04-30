footbawwl
=========

Some serious footbawwl in here.

A web server for hosting a fantasy American Football competition. Allows creation of users with a team name, selection of players and automated updates of player stats and scores.

Installation
============

You will need [rails](http://rubyonrails.org/download) before you can do anything. Once you have done that:

- Clone the repository:

    git clone git://github.com/ishakir/footbawwl

- Change into the directory created:

    cd footbawwl

- Install all the necessary gems

    (sudo) bundle install

- And start the rails server

    rails server

Contributing
============

If you're interested in contributing please get in contact with ishakir or MikeSpitz, we're putting this together in our spare time, so any help would be most welcome!

We use the standard rails testing frameworks in minitest and rubocop for static analysis. These are part of our verification process. In order to check that any changes are good first run rubocop from the top level:

    rubocop --rails --auto-correct

We use magic_encoding to insert the UTF-8 header into the ruby files, so if rubocop returns complaining about a missing utf-8 encoding comment, run:

    magic_encoding

Finally run the test cases, run:

    rake test
