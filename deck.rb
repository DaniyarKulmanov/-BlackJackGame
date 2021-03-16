# frozen_string_literal: true

require_relative 'constants'

module Deck
  attr_reader :cards

  def help
    puts 'Король, Дама, Валет = 10, Туз = 11 или 1'
  end

  def generate_deck
    self.cards = []
    simple_cards(cards)
    pic_cards(cards)
  end

  def count_points(_cards)
    21
  end

  def closed(cards)
    puts '🃏' * cards
  end

  def simple_cards(cards)
    NUM_CARDS.each do |num|
      SUITS.each { |suit| cards << create_card(num.to_s + suit, num) }
    end
  end

  def pic_cards(cards)
    PIC_CARDS.each do |pic|
      SUITS.each { |suit| cards << create_card(pic + suit, 10) }
    end
  end

  def create_card(card_suit, number)
    card = {}
    card[:card] = card_suit
    card[:point] = number
    card[:alter_points] = 11 if card_suit.include? 'Туз'
  end
end
