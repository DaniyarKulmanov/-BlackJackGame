# frozen_string_literal: true

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
  BASE_BET = 10
  ROUND_COUNT = 1
  DRAW = 'Ничья'

  attr_reader :bank, :round

  def initialize(interface)
    @interface = interface
    self.user = Player.new(interface.user_name)
    self.dealer = Dealer.new
    self.interface.user = user
    self.interface.dealer = dealer
  end

  def start
    base_money
    self.round = FIRST_ROUND
    play_rounds
  end

  private

  attr_writer :bank, :round
  attr_accessor :winner, :interface, :deck_cards

  def play_rounds
    loop do
      new_round
      user_turn
      dealer.turn(deck_cards) unless stop_game? || open_cards?
      round_result
      break if stop_game?
    end
    finish_game
  end

  def new_round
    initialize_round
    make_bet(user)
    make_bet(dealer)
    2.times do
      add_single_card(user.hand)
      add_single_card(dealer.hand)
    end
  end

  def add_single_card(hand)
    hand.add_card(deck_cards)
  end

  def user_turn
    interface.user_action(self)
    add_single_card(user.hand) if add_card?
  end

  def round_result
    round_winner
    interface.info_layout(dealer, hidden: false)
    interface.info_layout(user, hidden: false)
    interface.round_end(winner)
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
    self.winner = player.name
    player.money += bank
  end

  def draw
    self.winner = DRAW
    user.money += BASE_BET
    dealer.money += BASE_BET
  end

  def initialize_round
    user.hand.cards = []
    dealer.hand.cards = []
    self.winner = nil
    self.bank = INITIAL_VALUE
    deck = Deck.new
    self.deck_cards = deck.cards
  end

  def make_bet(player)
    player.money -= BASE_BET
    self.bank += BASE_BET
  end

  def base_money
    self.bank = INITIAL_VALUE
    dealer.money = BASE_MONEY
    user.money = BASE_MONEY
  end

  def finish_game
    input = interface.game_over
    start if input.to_i == NEW_GAME
  end
end
