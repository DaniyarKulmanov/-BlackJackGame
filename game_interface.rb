# frozen_string_literal: true

class GameInterface
  ASK_NAME = 'Введите Ваше имя'
  PLAYER_ACTIONS = ['0 - ⏳ Пропустить ход',
                    '1 - 🤏 Добавить карту',
                    '2 - 🔥 Открыть карты',
                    '3 - 🔥 Выход из игры'].freeze
  LINE = '=' * 40
  EXIT_MENU = ['♠️ ♣️ ♥️ ♦️ Игра законечна! ♠️ ♣️ ♥️ ♦️',
               'Нажмите 1 - 🔥 Новая игра!',
               'Введите любое значение и нажмите ENTER для завершение игры 😟'].freeze
  INFORMATION = ['Введите любое значение и нажмите ENTER для продолжения'].freeze
  HELP = 'Король, Дама, Валет = 10, Туз = 11 или 1'
  USER_COMMANDS = /^[0-3]$/.freeze

  attr_reader :user_name
  attr_accessor :user, :dealer

  def initialize
    @user_name = ask_name
  end

  def closed(cards)
    puts '🃏' * cards
  end

  def help
    puts HELP
  end

  def ask_name
    puts ASK_NAME
    gets.chomp
  end

  def user_action(game)
    loop do
      game.action = main_layout(game.round, game.bank)
      break if game.action =~ USER_COMMANDS
    end
  end

  def main_layout(round, bank)
    header(round, bank)
    info_layout(dealer)
    info_layout(user, hidden: false)
    footer
  end

  def footer
    puts LINE
    puts PLAYER_ACTIONS
    gets.chomp
  end

  def header(round, bank)
    system('clear')
    puts '⭐️ Игра BlackJack ⭐️'
    help
    puts "Текущий раунд: #{round}, ставка #{bank}"
  end

  def info_layout(player, hidden: true)
    puts LINE
    puts "Игрок #{player.name} $: #{player.money}"
    points = hidden ? '' : "Очки: #{player.hand.points}"
    puts points unless hidden
    display_cards(player.hand.cards, hidden)
  end

  def round_end(winner)
    puts "Выйграл 🏆 🏆 🏆 #{winner}🏆 🏆 🏆 "
    puts INFORMATION
    gets.chomp
  end

  def display_cards(cards, hidden)
    cards = hidden ? closed(cards.size) : cards
    cards ||= []
    cards.each { |card| print "#{card.suit}  " }
    puts '' unless hidden
  end

  def game_over
    puts EXIT_MENU
    gets.chomp
  end
end
