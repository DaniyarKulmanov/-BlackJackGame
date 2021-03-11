# frozen_string_literal: true

module Deck
  def help
    puts 'К - король, Д - дама, В - валет, А - туз'
  end

  def generate_deck
    puts 'new deck'
  end

  def count_points(_cards)
    21
  end
end
