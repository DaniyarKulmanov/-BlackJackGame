# frozen_string_literal: true

require_relative 'card'
require_relative 'deck'

class Hand
  attr_reader :points
  attr_accessor :cards

  def initialize
    @cards = []
    @points = 0
  end

  def enough_cards?
    cards.size == 3
  end

  def add_card(deck_cards)
    cards << deck_cards.sample
    count_points(cards)
    remove_cards_from_deck(deck_cards)
  end

  private

  attr_writer :points

  def count_points(cards)
    sum_no_aces(cards) unless ace?(cards)
    sum_with_aces(cards) if ace?(cards)
  end

  def sum_no_aces(cards)
    self.points = cards.sum(&:points)
  end

  def sum_with_aces(cards)
    aces = cards.select { |card| card.suit.include?(Deck::ACES) }
    simple_cards = cards.reject { |card| card.suit.include?(Deck::ACES) }
    sum_no_aces(simple_cards)
    sums = { alter_points_and_points: points, only_points: points, only_alter_points: points }
    count_aces(aces, sums)
  end

  def count_aces(aces, sums)
    aces.each do |card|
      sums[:alter_points_and_points] = sums[:only_points]
      sums[:only_points] += card.points
      sums[:only_alter_points] += card.alter_points
      sums[:alter_points_and_points] += card.alter_points
    end
    choose(sums)
  end

  def remove_cards_from_deck(deck)
    deck - cards
  end

  def ace?(cards)
    cards.find { |card| card.suit.include?(Deck::ACES) } != nil
  end

  def choose(sums)
    sums.sort_by(&:last)
    self.points = sums.select { |_key, value| value <= 21 }.max_by(&:last).last
  end
end
