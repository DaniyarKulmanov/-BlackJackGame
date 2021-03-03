# frozen_string_literal: true

require_relative 'player'
require_relative 'constants'

class Dealer < Player
  def initialize
    self.name = NAMES.sample
    super(name)
  end
end
