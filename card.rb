# frozen_string_literal: true

require_relative 'deck'

class Card
  SUITS = %w[♠️ ♣️ ♥️ ♦️].freeze

  attr_reader :suit, :points, :alter_points

  def initialize(suit, points)
    @suit = suit
    @points = points
    @alter_points = ace(suit)
  end

  private

  attr_writer :alter_points

  def ace(suit)
    suit.include?(Deck::ACES) ? 11 : 0
  end
end
