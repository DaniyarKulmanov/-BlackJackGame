# frozen_string_literal: true

class Hand
  MAX_POINTS = 21
  MAX_CARDS = 3

  attr_reader :cards, :points

  def initialize(cards, points)
    @cards = cards
    @points = points
  end
  # count point
  # enough cards?
end
