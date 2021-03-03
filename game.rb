# frozen_string_literal: true

# save game records and make leaderboard
require_relative 'dealer'
class Game
  @games = {}
  class << self
    attr_accessor :games
  end

  attr_reader :player, :dealer

  def initialize(player)
    @player = player
    create_dealer
    add_money_to_players
  end

  private

  attr_writer :player, :dealer

  def create_dealer
    self.dealer = Dealer.new
  end

  def finish_game
    game = {}
    game[:winner] = 'winner'
    game[:date] = 'date'
    game[:time] = 'date'
  end
end
