# frozen_string_literal: true

# save game records and make leaderboard
require 'pry'
require_relative 'player'
require_relative 'dealer'
require_relative 'deck'
require_relative 'game_interface'
require_relative 'validations'

class Game
  include Validations

  BASE_MONEY = 100
  INITIAL_VALUE = 0
  FIRST_ROUND = 1
  NEW_GAME = 1
  ADD_CARD = 1
  OPEN_CARDS = 2
  STOP_GAME = 3
  BASE_BET = 10
  ROUND_COUNT = 1

  attr_reader :bank, :user, :dealer, :round
  attr_accessor :action

  def initialize(interface)
    @interface = interface
    create_player
    create_dealer
    self.interface.user = user
    self.interface.dealer = dealer
  end

  def start
    base_money
    self.round = FIRST_ROUND
    play_rounds
  end

  private

  attr_writer :bank, :user, :dealer, :round
  attr_accessor :winner, :interface

  def play_rounds
    loop do
      new_round unless add_card?
      user_turn
      dealer_turn unless open_cards?
      round_check
      break if stop_game?
    end
    finish_game
  end

  def user_turn
    user_action(self)
    add_card(user) if add_card? && user_cards_not_max?
  end

  def round_check
    if bankrupt?
      self.action = STOP_GAME
      round_result
    elsif next_round?
      round_result
      clean_user_input
    end
  end

  def clean_user_input
    self.action = INITIAL_VALUE
  end

  def round_result
    round_winner
    interface.info_layout(dealer, hidden: false)
    interface.info_layout(user, hidden: false)
    round_end(winner)
    self.round += ROUND_COUNT
  end

  def round_winner
    points_in_limit if both_in_limit?
    won(user) if dealer_points_exceed?
    won(dealer) if user_points_exceed?
    draw if both_exceed?
  end

  def points_in_limit
    won(user) if user_points_better?
    won(dealer) if dealer_points_better?
    draw if draw?
  end

  def won(player)
    self.winner = player.user_name
    player.money += bank
  end

  def draw
    self.winner = DRAW
    user.money += BASE_BET
    dealer.money += BASE_BET
  end

  def dealer_turn
    add_card(dealer) if dealer.points < DEALER_POINTS && action != OPEN_CARDS
  end

  def new_round
    initialize_round
    make_bet(user)
    make_bet(dealer)
    # deck = Deck.new
    2.times { add_card(user) }
    2.times { add_card(dealer) }
  end

  def initialize_round
    user.cards = []
    dealer.cards = []
    self.winner = nil
    self.bank = INITIAL_VALUE
  end

  def make_bet(player)
    player.money -= BASE_BET
    self.bank += BASE_BET
  end

  def create_player
    self.user = Player.new(interface.user_name)
  end

  def create_dealer
    self.dealer = Dealer.new
  end

  def base_money
    self.bank = INITIAL_VALUE
    dealer.money = BASE_MONEY
    user.money = BASE_MONEY
  end

  def finish_game
    user_input = game_over
    start if user_input.to_i == NEW_GAME
  end
end
