# frozen_string_literal: true

module GameInterface
  ASK_NAME = 'Введите Ваше имя'
  PLAYER_ACTIONS = ['Введите любое значение и нажмите ENTER чтобы пропустить ход️ ⏳',
                    '1 - 🤏 Добавить карту',
                    '2 - 🔥 Открыть карты',
                    '3 - 🔥 Выход из игры'].freeze
  LINE = '=' * 40
  DRAW = 'Ничья'
  EXIT_MENU = ['♠️ ♣️ ♥️ ♦️ Игра законечна! ♠️ ♣️ ♥️ ♦️',
               'Нажмите 1 - 🔥 Новая игра!',
               'Введите любое значение и нажмите ENTER для завершение игры 😟'].freeze
  INFORMATION = ['Введите любое значение и нажмите ENTER для продолжения'].freeze

  def closed(cards)
    puts '🃏' * cards
  end

  def help
    puts HELP
  end

  def print_ask_name
    puts ASK_NAME
    gets.chomp
  end

  def print_game_interface(dealer, user, round, bank)
    print_game_header(round, bank)
    print_information(dealer)
    print_information(user, hidden: false)
    print_footer
  end

  def print_footer
    puts LINE
    puts PLAYER_ACTIONS
    gets.chomp
  end

  def print_game_header(round, bank)
    system('clear')
    puts '⭐️ Игра BlackJack ⭐️'
    help
    puts "Текущий раунд: #{round}, ставка #{bank}"
  end

  def print_information(player, hidden: true)
    print_header(player)
    print_points(player, hidden)
    print_cards(player, hidden)
  end

  def print_round_footer(winner)
    puts "Выйграл 🏆 🏆 🏆 #{winner}🏆 🏆 🏆 "
    puts INFORMATION
    gets.chomp
  end

  def print_header(player)
    puts LINE
    puts "Игрок #{player.name} $: #{player.money}"
  end

  def print_points(player, hidden)
    points = hidden ? '' : "Очки: #{player.points}"
    puts points unless hidden
  end

  def print_cards(player, hidden)
    cards = hidden ? closed(player.cards.size) : player.cards
    cards ||= []
    cards.each { |card| print "#{card[:card]}  " }
    puts '' unless hidden
  end

  def print_game_exit
    puts EXIT_MENU
    gets.chomp
  end

  def print_show_cards(dealer, user)
    print_information(dealer, hidden: false)
    print_information(user, hidden: false)
  end
end
