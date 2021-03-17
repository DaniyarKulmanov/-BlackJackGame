# frozen_string_literal: true

# save game records and make leaderboard
require_relative 'player'
require_relative 'dealer'
require_relative 'constants'
require_relative 'deck'
require_relative 'game_interface'

class Game
  include Deck
  include GameInterface

  @games = {}
  class << self
    attr_accessor :games
  end

  attr_reader :user, :dealer, :bank

  def initialize
    create_player
    create_dealer
  end

  def start
    base_money
    self.round = 1
    play
  end

  private

  attr_writer :user, :dealer, :bank
  attr_accessor :round

  def play
    loop do
      new_round
      self.round += 1
      break if round > 1
    end
  end

  def new_round
    round_money_bets
    generate_deck
    2.times { players_add_cards(user) }
    2.times { players_add_cards(dealer) }
    print_game_interface(dealer, user)
  end

  # TODO: add validation below zero
  def round_money_bets
    user.money -= 10
    dealer.money -= 10
    self.bank += 20
  end

  def players_add_cards(player)
    player.cards << cards.sample
    player.points = count_points(player)
    remove_cards_from_deck(player.cards)
  end

  def count_points(player)
    player.points = player.cards.sum { |card| card[:point] }
  end

  def remove_cards_from_deck(player_cards)
    self.cards -= player_cards
  end

  def create_player
    self.user = Player.new(print_ask_name.capitalize)
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
