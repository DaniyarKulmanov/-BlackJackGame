# frozen_string_literal: true

# save game records and make leaderboard
require_relative 'dealer'
class Game
  @games = {}
  class << self
    attr_accessor :games
  end

  attr_reader :user, :dealer, :bank

  def initialize
    create_player
    create_dealer
    base_money
  end

  def start
    # round.cards_initialize
    # players.money -= 10 & bank += 20
    # players.cards += 2
    puts user.inspect
    puts dealer.inspect
    puts "bank = #{bank}"
  end

  private

  attr_writer :user, :dealer, :bank

  def create_player
    self.user = Player.new(ask_name.capitalize)
  end

  def ask_name
    puts ASK_NAME
    gets.chomp
  end

  def create_dealer
    self.dealer = Dealer.new
  end

  def base_money
    self.bank = 0
    dealer.money = BASE_MONEY
    user.money = BASE_MONEY
  end

  # save statistics
  def finish_game; end
end
