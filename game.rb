# frozen_string_literal: true

# save game records and make leaderboard
require 'pry'
require_relative 'player'
require_relative 'dealer'
require_relative 'constants'
require_relative 'deck'
require_relative 'game_interface'

class Game
  include Deck
  include GameInterface

  attr_reader :user, :dealer, :bank

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

  attr_writer :user, :dealer, :bank
  attr_accessor :round, :action, :winner

  # TODO: ACE logic
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
    add_card(user) if add_card?
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

  def next_round?
    points_above? || draw? || open_cards? || both_triple_cards?
  end

  def both_triple_cards?
    user.cards.size == MAX_CARDS && dealer.cards.size == MAX_CARDS
  end

  def points_above?
    user.points > MAX_POINTS || dealer.points > MAX_POINTS
  end

  def draw?
    user.points == dealer.points
  end

  def bankrupt?
    user.money.zero? || dealer.money.zero?
  end

  def round_result
    round_winner
    show_cards
    print_round_footer(winner)
    self.round += ROUND_COUNT
  end

  def round_winner
    points_in_limit if both_in_limit?
    won(user) if dealer_points_exceed?
    won(dealer) if user_points_exceed?
    draw if both_exceed?
  end

  def both_in_limit?
    user.points <= MAX_POINTS && dealer.points <= MAX_POINTS
  end

  def dealer_points_exceed?
    user.points <= MAX_POINTS && dealer.points > MAX_POINTS
  end

  def user_points_exceed?
    dealer.points <= MAX_POINTS && user.points > MAX_POINTS
  end

  def both_exceed?
    user.points > MAX_POINTS && dealer.points > MAX_POINTS
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

  def user_points_better?
    user.points > dealer.points
  end

  def dealer_points_better?
    user.points < dealer.points
  end

  def open_cards?
    action.to_i == OPEN_CARDS
  end

  def add_card?
    action.to_i == ADD_CARD
  end

  def dealer_turn
    add_card(dealer) if dealer.points < DEALER_POINTS && action != OPEN_CARDS
  end

  def stop_game?
    action.to_i == STOP_GAME || bankrupt?
  end

  def new_round
    initialize_round
    make_bet(user)
    make_bet(dealer)
    generate_deck
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
    sum_no_aces(player) unless ace?(player.cards)
    sum_with_aces(player) if ace?(player.cards)
  end

  def ace?(cards)
    cards.find { |card| card[:card].include?(ACE) } != nil
  end

  def sum_no_aces(player)
    player.points = player.cards.sum { |card| card[:point] }
  end

  def sum_with_aces(player)
    # TODO: count with aces each
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
    self.bank = INITIAL_VALUE
    dealer.money = BASE_MONEY
    user.money = BASE_MONEY
  end

  # save statistics
  def finish_game
    user_input = print_game_exit
    start if user_input.to_i == NEW_GAME
  end

  def show_cards
    print_information(dealer, hidden: false)
    print_information(user, hidden: false)
  end
end
