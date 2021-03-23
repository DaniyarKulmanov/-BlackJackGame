# frozen_string_literal: true

require_relative 'player'

class Dealer < Player
  DEALER_POINTS = 17

  def initialize
    self.name = "Диллер #{NAMES.sample}"
    super(name)
  end
end
