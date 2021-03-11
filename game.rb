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
    # players.cards += 2
    game_interface
  end

  def game_interface
    game_header
    player_information(dealer)
    player_information(user, false)
    puts '====================='
    puts PLAYER_ACTIONS
  end

  def game_header
    system('clear')
    puts '⭐️ Игра BlackJack ⭐️'
    help
    puts "Текущий раунд: #{round}"
  end

  # TODO: fix bug
  def player_information(player, hidden = true)
    puts '====================='
    puts "Игрок #{player.name} $: #{player.money}"
    points = hidden ? '' : "Очки: #{count_points(player.cards)}"
    puts points unless hidden
    cards = hidden ? '🃏🃏🃏' : player.cards
    puts cards
  end

  # TODO: add validation below zero
  def round_money_bets
    user.money -= 10
    dealer.money -= 10
    self.bank += 20
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
