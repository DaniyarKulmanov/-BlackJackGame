# frozen_string_literal: true

require_relative 'card'

class Deck
  ACES = 'Туз'
  BLACK_JACK_DECK = { 'Король' => 10, 'Дама' => 10, 'Валет' => 10, 'Туз' => 1,
                      '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7,
                      '8' => 8, '9' => 9, '10' => 10 }.freeze
  attr_accessor :cards

  def initialize
    @cards = []
    create_cards
  end

  def create_cards
    BLACK_JACK_DECK.each do |card, value|
      Card::SUITS.each { |suit| cards << Card.new(card + suit, value) }
    end
  end
end
