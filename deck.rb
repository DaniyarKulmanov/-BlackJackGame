# frozen_string_literal: true
require_relative 'card'

module Deck
  SUITS = %w[♠️ ♣️ ♥️ ♦️].freeze
  PIC_CARDS = %w[Туз Король Дама Валет].freeze
  NUM_CARDS = (2..10).freeze
  HELP = 'Король, Дама, Валет = 10, Туз = 11 или 1'

  attr_accessor :cards

  def help
    puts HELP
  end

  def generate_deck
    self.cards = []
    simple_cards(cards)
    pic_cards(cards)
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
    card[:point] = card_suit.include?(PIC_CARDS[0]) ? 1 : number
    card[:alter_point] = 11 if card_suit.include? PIC_CARDS[0]
    card
  end
end
