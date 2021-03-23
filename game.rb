# frozen_string_literal: true

# save game records and make leaderboard
require 'pry'
require_relative 'player'
require_relative 'dealer'
require_relative 'deck'
require_relative 'game_interface'
require_relative 'validations'

class Game
  include GameInterface
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
  USER_COMMANDS = /^[1-3]$/.freeze

  attr_reader :bank

  def initialize
    create_player
    create_dealer
  end

  def start
    base_money
    self.round = FIRST_ROUND
    play_rounds
  end

  private

  attr_writer :bank
  attr_accessor :round, :winner

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
    loop do
      self.action = print_game_interface(dealer, user, round, bank)
      break if action =~ USER_COMMANDS
    end
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
    print_show_cards(dealer, user)
    print_round_footer(winner)
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

  def add_card(player)
    player.cards << cards.sample
    count_points(player)
    remove_cards_from_deck(player.cards)
  end

  def count_points(player)
    sum_no_aces(player, player.cards) unless ace?(player.cards)
    sum_with_aces(player) if ace?(player.cards)
  end

  def sum_no_aces(player, simple_cards)
    player.points = simple_cards.sum { |card| card[:point] }
  end

  def sum_with_aces(player)
    aces = player.cards.reject { |card| card[:alter_point].nil? }
    simple_cards = player.cards.select { |card| card[:alter_point].nil? }
    sum_no_aces(player, simple_cards)
    points = player.points
    sums = [points, points, points]
    count_aces(aces, sums)
    player.points = sums.select { |sum| sum <= 21 }.last
  end

  def count_aces(aces, sums)
    aces.each do |card|
      sums[2] = sums[0]
      sums[0] += card[:point]
      sums[1] += card[:alter_point]
      sums[2] += card[:alter_point]
    end
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
    self.bank = INITIAL_VALUE
    dealer.money = BASE_MONEY
    user.money = BASE_MONEY
  end

  def finish_game
    user_input = print_game_exit
    start if user_input.to_i == NEW_GAME
  end
end
