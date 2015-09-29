#!/usr/bin/env ruby

require_relative 'lib/chess/game'

system('clear')

game = Game.new
game.setup
game.play
