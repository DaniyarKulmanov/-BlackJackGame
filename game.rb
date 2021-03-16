# frozen_string_literal: true

# save game records and make leaderboard
require_relative 'player'
require_relative 'dealer'
require_relative 'constants'
require_relative 'deck'

class Game
  include Deck

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
    game_interface
  end

  # TODO: add validation below zero
  def round_money_bets
    user.money -= 10
    dealer.money -= 10
    self.bank += 20
  end

  def players_add_cards(player)
    player.cards << cards.sample
    remove_cards_from_deck(player.cards)
  end

  def remove_cards_from_deck(player_cards)
    self.cards -= player_cards
  end

  def game_interface
    game_header
    player_information(dealer)
    player_information(user, hidden: false)
    puts '====================='
    puts PLAYER_ACTIONS
  end

  def game_header
    system('clear')
    puts '⭐️ Игра BlackJack ⭐️'
    help
    puts "Текущий раунд: #{round}"
  end

  def player_information(player, hidden: true)
    print_header(player)
    print_points(player, hidden)
    print_cards(player, hidden)
  end

  def print_header(player)
    puts '====================='
    puts "Игрок #{player.name} $: #{player.money}"
  end

  def print_points(player, hidden)
    points = hidden ? '' : "Очки: #{count_points(player.cards)}"
    puts points unless hidden
  end

  def print_cards(player, hidden)
    cards = hidden ? closed(player.cards.size) : player.cards
    cards ||= []
    cards.each { |card| puts card[:card] }
  end

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
