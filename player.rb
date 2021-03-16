# frozen_string_literal: true

class Player
  attr_reader :name
  attr_accessor :money, :cards

  def initialize(name)
    @name = name
    @cards = []
    @money = 0
  end

  private

  attr_writer :name
end
