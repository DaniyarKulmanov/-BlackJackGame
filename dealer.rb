# frozen_string_literal: true

require_relative 'player'
require_relative 'constants'

class Dealer < Player
  def initialize
    self.name = "Диллер #{NAMES.sample}"
    super(name)
  end
end
