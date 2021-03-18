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
    self.round = 0
    new_round
    play
    finish_game
  end

  private

  attr_writer :user, :dealer, :bank
  attr_accessor :round, :action

  def play
    loop do
      self.round += ROUND_COUNT
      self.action = print_game_interface(dealer, user)
      # send :method - user input
      break if stop_game?
    end
  end

  def stop_game?
    action.to_i == OPEN_CARDS || (user.points > 21 || dealer.points > 21)
  end

  def new_round
    refresh_player_cards
    round_money_bets
    generate_deck
    2.times { players_add_cards(user) }
    2.times { players_add_cards(dealer) }
  end

  def refresh_player_cards
    user.cards = []
    dealer.cards = []
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
  def finish_game
    user_input = print_game_exit
    start if user_input.to_i == FIRST_ROUND
  end
end
