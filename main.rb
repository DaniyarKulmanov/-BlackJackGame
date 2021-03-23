# frozen_string_literal: true

require_relative 'game'
require_relative 'game_interface'

interface = GameInterface.new
game = Game.new(interface)
game.start
