# frozen_string_literal: true

require_relative 'card'

class Deck
  SUITS = %w[♠️ ♣️ ♥️ ♦️].freeze
  PIC_CARDS = %w[Туз Король Дама Валет].freeze
  NUM_CARDS = (2..10).freeze
  HELP = 'Король, Дама, Валет = 10, Туз = 11 или 1'

  attr_accessor :cards

  def initialize
    @cards = []
    simple_cards(cards)
    pic_cards(cards)
  end

  def simple_cards(cards)
    NUM_CARDS.each do |num|
      SUITS.each { |suit| cards << Card.new(num.to_s + suit, num) }
    end
  end

  def pic_cards(cards)
    PIC_CARDS.each do |pic|
      SUITS.each { |suit| cards << Card.new(pic + suit, 10) }
    end
  end
end
