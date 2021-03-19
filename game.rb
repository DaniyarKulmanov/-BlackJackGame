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
    new_round
    play
    finish_game
  end

  private

  attr_writer :user, :dealer, :bank
  attr_accessor :round, :action

  # TODO: bug when open_cards round, money refreshing
  def play
    loop do
      self.action = print_game_interface(dealer, user)
      players_turn
      round_check unless open_cards?
      break if stop_game?
    end
  end

  def round_check
    if bankrupt?
      self.action = STOP_GAME
    elsif next_round?
      round_result
      new_round
    end
  end

  def next_round?
    points_above? || draw?
  end

  def points_above?
    user.points > 21 || dealer.points > 21
  end

  def draw?
    user.points == dealer.points
  end

  def bankrupt?
    user.money.zero? || dealer.money.zero?
  end

  def round_result
    show_cards
    print_round_footer
    self.round += ROUND_COUNT
  end

  def players_turn
    user_turn
    dealer_turn unless open_cards?
  end

  def open_cards?
    action.to_i == OPEN_CARDS
  end

  def user_turn
    players_add_cards(user) if action.to_i == 1
    open_cards_all if action.to_i == 2
  end

  def open_cards_all
    round_result
    new_round
    play
  end

  def dealer_turn
    players_add_cards(dealer) if dealer.points < 17
  end

  def stop_game?
    action.to_i == STOP_GAME
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

  def show_cards
    print_information(dealer, hidden: false)
    print_information(user, hidden: false)
  end
end
