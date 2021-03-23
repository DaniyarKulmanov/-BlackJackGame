# frozen_string_literal: true
require_relative 'card'

class Hand
  MAX_POINTS = 21
  MAX_CARDS = 3
  ACE = 'Туз'

  attr_reader :cards, :points

  def initialize
    @cards = []
    @points = 0
  end

  def enough_cards?
    cards.size == 3
  end

  def add_card(card, deck)
    cards << card
    count_points(cards)
    remove_cards_from_deck(deck)
  end

  private

  attr_writer :points, :cards

  def count_points(cards)
    sum_no_aces(cards) unless ace?(cards)
    sum_with_aces(cards) if ace?(cards)
  end

  def sum_no_aces(cards)
    self.points = cards.sum(&:points)
  end

  def sum_with_aces(cards)
    aces = cards.select { |card| card.suit.include?(ACE) }
    simple_cards = cards.reject { |card| card.suit.include?(ACE) }
    sum_no_aces(simple_cards)
    sums = [points, points, points]
    count_aces(aces, sums)
    self.points = sums.select { |sum| sum <= 21 }.last
  end

  def count_aces(aces, sums)
    aces.each do |card|
      sums[2] = sums[0]
      sums[0] += card.points
      sums[1] += card.alter_points
      sums[2] += card.alter_points
    end
  end

  def remove_cards_from_deck(deck)
    deck.cards -= cards
  end

  def ace?(cards)
    cards.find { |card| card.suit.include?(ACE) } != nil
  end
end
