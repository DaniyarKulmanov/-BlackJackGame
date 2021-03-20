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
  attr_accessor :round, :action

  # TODO: after open cards, stop game not triggering
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
      self.action = print_game_interface(dealer, user)
      break if action =~ USER_COMMANDS
    end
    user_action
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
    points_above? || draw? || open_cards?
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
    show_cards
    print_round_footer(round_winner)
    self.round += ROUND_COUNT
  end

  # TODO: bug winner not seen if open cards
  def round_winner
    if user.points <= MAX_POINTS && dealer.points <= MAX_POINTS
      puts "points user #{user.points} / dealer #{dealer.points}"
      user.name if user.points > dealer.points
      dealer.name if user.points < dealer.points
      'draw' if user.points == dealer.points
    elsif user.points <= MAX_POINTS && dealer.points > MAX_POINTS
      user.name
    elsif dealer.points <= MAX_POINTS && user.points > MAX_POINTS
      dealer.name
    elsif user.points > MAX_POINTS && dealer.points > MAX_POINTS
      'draw'
    end
  end

  def open_cards?
    action.to_i == OPEN_CARDS
  end

  def user_action
    add_card(user) if add_card?
  end

  def add_card?
    action.to_i == ADD_CARD
  end

  def dealer_turn
    add_card(dealer) if dealer.points < DEALER_POINTS && action != OPEN_CARDS
  end

  def stop_game?
    action.to_i == STOP_GAME
  end

  def new_round
    refresh_player_cards
    make_bet(user)
    make_bet(dealer)
    generate_deck
    2.times { add_card(user) }
    2.times { add_card(dealer) }
  end

  def refresh_player_cards
    user.cards = []
    dealer.cards = []
  end

  def make_bet(player)
    player.money -= BASE_BET
    self.bank += BASE_BET
  end

  def add_card(player)
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
