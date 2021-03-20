# frozen_string_literal: true

module GameInterface
  def print_ask_name
    puts ASK_NAME
    gets.chomp
  end

  def print_game_interface(dealer, user)
    print_game_header
    print_information(dealer)
    print_information(user, hidden: false)
    print_footer
  end

  def print_footer
    puts LINE
    puts PLAYER_ACTIONS
    gets.chomp
  end

  def print_game_header
    system('clear')
    puts '⭐️ Игра BlackJack ⭐️'
    help
    puts "Текущий раунд: #{round}"
  end

  def print_information(player, hidden: true)
    print_header(player)
    print_points(player, hidden)
    print_cards(player, hidden)
  end

  def print_round_footer(winner)
    puts "Выйграл 🏆 🏆 🏆 #{winner.name}🏆 🏆 🏆 "
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
end
