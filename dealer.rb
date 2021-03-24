# frozen_string_literal: true

require_relative 'player'

class Dealer < Player
  DEALER_POINTS = 17

  def initialize
    self.name = "Диллер #{NAMES.sample}"
    super(name)
  end

  def turn(deck_cards)
    hand.add_card(deck_cards) if max_points?
  end

  private

  def max_points?
    hand.points < DEALER_POINTS
  end
end
