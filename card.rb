# frozen_string_literal: true

class Card
  ACE = 'Туз'

  attr_reader :suit, :points, :alter_points

  def initialize(suit, points)
    @suit = suit
    @points = points
    @alter_points = ace(suit)
  end

  private

  attr_writer :alter_points

  def ace(suit)
    suit.include?(ACE) ? 11 : 0
  end
end
